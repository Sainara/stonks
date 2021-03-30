//
//  YoustersButton.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 12.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import SnapKit
import Haptica

class TommyButton: UIButton {
    
    private var onTapAction:(()->Void)?

    init() {
        super.init(frame: .zero)
    }
    
    convenience init(text:String, fontSize: CGFloat = 17, image:UIImage? = nil, height:CGFloat = 55, style:YoustersButtonStyle = .basic, onTap:(()->Void)? = nil) {
        self.init()
        setup(text: text, size: fontSize, image: image, height: height, style: style)
        addOnTapTarget(onTapAction: onTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setup(text:String, size:CGFloat, image:UIImage?, height:CGFloat, style:YoustersButtonStyle) {
        
        setTitle(text, for: .normal)
        
        switch style {
        case .basic:
            setBackgroundColor(color: .bgColor, forState: .normal)
            setBackgroundColor(color: .buttonDisabled, forState: .disabled)
            setBackgroundColor(color: .buttonHighlited, forState: .highlighted)
            titleLabel?.textColor = .white
            isHaptic = true
            hapticType = .impact(.light)
        case .secondary:
            setBackgroundColor(color: .coreBlue, forState: .normal)
            setBackgroundColor(color: .secondaryButtonDisabled, forState: .disabled)
            setBackgroundColor(color: .secondaryButtonHighlited, forState: .highlighted)
            setTitleColor(.bgColor, for: .normal)
            setTitleColor(.white, for: .normal)
        case .exit:
            titleLabel?.textColor = .redColor
            isHaptic = true
            hapticType = .impact(.light)
        case .profile:
            setBackgroundColor(color: .bgColor, forState: .normal)
            setBackgroundColor(color: .buttonDisabled, forState: .disabled)
            setBackgroundColor(color: .buttonHighlited, forState: .highlighted)
            setTitle("", for: .normal)
            
            let coreStack = UIStackView()
            
            addSubview(coreStack)
            coreStack.fillSuperview(padding: .init(top: 10, left: 15, bottom: 10, right: 15))
            coreStack.distribution = .fill
            coreStack.alignment = .center
            coreStack.spacing = 8
            coreStack.isUserInteractionEnabled = false
            
            let image = UIImageView(image: image)
            image.snp.makeConstraints { (make) in
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            coreStack.addArrangedSubview(image)
            
            let title = UILabel(text: text, font: Fonts.standart.gilroyMedium(ofSize: size), textColor: .white, textAlignment: .left, numberOfLines: 1)
            coreStack.addArrangedSubview(title)
            
            let cvImage = UIImageView(image: UIImage(imageLiteralResourceName: "chevron-right"))
            cvImage.snp.makeConstraints { (make) in
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            coreStack.addArrangedSubview(cvImage)
            
            isHaptic = true
            hapticType = .impact(.light)
        }
        
        snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
        layer.cornerRadius = 10
        clipsToBounds = true
        titleLabel?.font = Fonts.standart.gilroyMedium(ofSize: size)
    }
    
    func setOnTapAction(onTapAction:(()->Void)?) {
        self.onTapAction = onTapAction
    }
    
    internal func addOnTapTarget(onTapAction:(()->Void)?) {
        self.onTapAction = onTapAction
        
        addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    @objc func onTap() {
        if let onTapAction = onTapAction {
            onTapAction()
        }
    }
    
    enum YoustersButtonStyle {
        case basic, secondary, profile, exit
    }

}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

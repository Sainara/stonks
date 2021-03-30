//
//  TommyTextFieldWrapped.swift
//  MixApp
//
//  Created by Ян Мелоян on 17.11.2020.
//

import UIKit

class TommyTextFieldWrapped:UIView {
    
    var value = ""
    
    weak var delegate:TextInputDelegate?
    
    private let textField:TommyTextField
    
    private var checkImage:UIImageView!
    private var checkedImage:UIImage?
    
    private var isChecked:Bool = false
    private var isWithRemove:Bool = false
    
    private var isNeedScroll = true
    
    init(placeholder:String, paddings:UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)) {
        textField = TommyTextField(placehldr: placeholder)
        super.init(frame: .zero)
        
        backgroundColor = .lightBlack
        
        addSubview(textField)
        textField.fillSuperview(padding: paddings)
        textField.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldBeginEdit(textField:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldEndEdit(textField:)), for: .editingDidEnd)
    }
    
    convenience init(placeholder:String, checkedImage:UIImage, isWithRemove:Bool = false) {
        self.init(placeholder: placeholder, paddings: .init(top: 15, left: 20, bottom: 15, right: 50))
        self.checkedImage = checkedImage
        self.isWithRemove = isWithRemove
        if isWithRemove {
            checkImage = UIImageView(image: UIImage(imageLiteralResourceName: "remove"))
        } else {
            checkImage = UIImageView(image: checkedImage)
            checkImage.alpha = 0
        }
        addSubview(checkImage)
        checkImage?.snp.makeConstraints({ (make) in
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        })
        
        checkImage.isUserInteractionEnabled = isWithRemove
        let tap = UITapGestureRecognizer(target: self, action: #selector(onImageTap))
        checkImage.addGestureRecognizer(tap)
    }
    
    func setChecked() {
       
        checkImage.alpha = 1
        checkImage.image = checkedImage
        isChecked = true
    }
    
    func setUnCheck() {
        if !isWithRemove {
            checkImage.alpha = 0
        }
        checkImage.image = UIImage(imageLiteralResourceName: "remove")
        isChecked = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(value:String) {
        textField.text = value
    }
    
    @objc private func textFieldBeginEdit(textField: TommyTextField) {
        delegate?.textBeginEditing()
    }
    
    @objc private func textFieldEndEdit(textField: TommyTextField) {
        isNeedScroll = true
        //delegate?.textBeginEditing()
    }
    
    @objc private func textChanged(textField:TommyTextField) {
        value = textField.text ?? ""
        delegate?.textChanged(text: value)
        
        if textField.text!.count >= 3 && isNeedScroll {
            isNeedScroll = false
            self.delegate?.textBeginEditing()
        }
    }
    
    @objc private func onImageTap() {
        print("@objc private func onImageTap() {")
        if !isChecked {
            delegate?.rightImageClicked()
        }
    }
}

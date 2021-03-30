//
//  CommentsView.swift
//  MixApp
//
//  Created by Ян Мелоян on 08.11.2020.
//

import UIKit

class CommentsView: UIView {
    
    let coreStack = UIStackView()
    
    let mix:Mix
    
    init(mix:Mix) {
        self.mix = mix
        super.init(frame: .zero)
        
        addSubview(coreStack)
        coreStack.fillSuperview(padding: .allSides(15))
        
        coreStack.axis = .vertical
        coreStack.spacing = 25
        coreStack.distribution = .fill
        coreStack.alignment = .fill
        coreStack.isLayoutMarginsRelativeArrangement = true
        
        setupView()
    }
    
    func setupView() {
        
        coreStack.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        let title = UILabel(text: "Комментарии", font: Fonts.standart.gilroySemiBoldName(ofSize: 27), textColor: .white, textAlignment: .left, numberOfLines: 1)
        title.snp.makeConstraints { (make) in
            make.width.equalTo("Комментарии".widthOfString(usingFont: Fonts.standart.gilroySemiBoldName(ofSize: 27)) + 7)
        }
        
        let count = UILabel(text: "\(mix.comments.count)", font: Fonts.standart.gilroySemiBoldName(ofSize: 27), textColor: .lightGray, textAlignment: .left, numberOfLines: 1)
        let wrap = UIView()
        let stack = hstack(title, count, alignment: .leading)
        wrap.addSubview(stack)
        stack.fillSuperview()
        
        coreStack.addArrangedSubview(wrap)
        
        if mix.comments.isEmpty {
            let emptyLabel = UILabel(text: "Пока нет ни одного комментария", font: Fonts.standart.gilroyMedium(ofSize: 16), textColor: .lightGray, textAlignment: .left, numberOfLines: 0)
            coreStack.addArrangedSubview(emptyLabel)
            coreStack.layoutMargins = .init(top: 0, left: 0, bottom: 30, right: 0)
        }
        
        for comment in mix.comments {
            coreStack.addArrangedSubview(CommentView(comment: comment))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommentsView: ReloadProtocol {
    func reload() {
        coreStack.arrangedSubviews.forEach({$0.removeFromSuperview()})
        setupView()
    }
}

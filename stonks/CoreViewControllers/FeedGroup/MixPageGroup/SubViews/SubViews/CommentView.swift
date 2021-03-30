//
//  CommentView.swift
//  MixApp
//
//  Created by Ян Мелоян on 08.11.2020.
//

import UIKit

class CommentView: UIView {
    
    let comment:Comment
    
    let coreStack = UIStackView()
    
    init(comment:Comment) {
        self.comment = comment
        super.init(frame: .zero)
        
        addSubview(coreStack)
        coreStack.fillSuperview()
        
        //coreStack.isLayoutMarginsRelativeArrangement = true
        coreStack.axis = .vertical
        //coreStack.layoutMargins = .allSides(15)
        coreStack.spacing = 2
        coreStack.distribution = .fill
        coreStack.alignment = .fill
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let title = UILabel(text: "\(comment.creatorName)", font: Fonts.standart.gilroySemiBoldName(ofSize: 16), textColor: .white, textAlignment: .left, numberOfLines: 1)
        
        coreStack.addArrangedSubview(title)
        
        let date = UILabel(text: "\(comment.createAt.timeAgo(numericDates: false))", font: Fonts.standart.gilroyMedium(ofSize: 14), textColor: .lightGray, textAlignment: .left, numberOfLines: 1)
        
        coreStack.addArrangedSubview(date)
        coreStack.setCustomSpacing(10, after: date)
        
        let text = UILabel(text: "\(comment.content)", font: Fonts.standart.gilroyMedium(ofSize: 18), textColor: .white, textAlignment: .left, numberOfLines: 0)
        
        coreStack.addArrangedSubview(text)
    }
}

//
//  IngridientView.swift
//  MixApp
//
//  Created by Ян Мелоян on 09.11.2020.
//

import UIKit

class IngridientView: UIView {
    
    let ingridient:TabacoAsIngridient
    let width:CGFloat
        
    init(ingridient:TabacoAsIngridient, width:CGFloat) {
        self.ingridient = ingridient
        self.width = width
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        let persentage = "\(ingridient.percentage)%"
        
        let count = UILabel(text: persentage, font: Fonts.standart.gilroySemiBoldName(ofSize: 27), textColor: .lightGray, textAlignment: .left, numberOfLines: 1)
        count.snp.makeConstraints { (make) in
            make.width.equalTo(width)
        }
        
        let ingr = ingridient.tabaco.getFormatedName()
        
        let title = UILabel(text: ingr, font: Fonts.standart.gilroyMedium(ofSize: 18), textColor: .white, textAlignment: .left, numberOfLines: 0)
//        title.snp.makeConstraints { (make) in
//            make.width.equalTo(ingr.widthOfString(usingFont: Fonts.standart.gilroyMedium(ofSize: 18)) + 5)
//        }
    
        let stack = hstack(count, title, alignment: .top)
        addSubview(stack)
        stack.fillSuperview()
//        let title = UILabel(text: "\(comment.creatorId)", font: Fonts.standart.gilroySemiBoldName(ofSize: 16), textColor: .white, textAlignment: .left, numberOfLines: 1)
//
//        coreStack.addArrangedSubview(title)
//
//        let date = UILabel(text: "\(comment.createAt.timeAgo(numericDates: false))", font: Fonts.standart.gilroyMedium(ofSize: 14), textColor: .lightGray, textAlignment: .left, numberOfLines: 1)
//
//        coreStack.addArrangedSubview(date)
//        coreStack.setCustomSpacing(10, after: date)
//
//        let text = UILabel(text: "\(comment.content)", font: Fonts.standart.gilroyMedium(ofSize: 18), textColor: .white, textAlignment: .left, numberOfLines: 0)
//
//        coreStack.addArrangedSubview(text)
    }
}

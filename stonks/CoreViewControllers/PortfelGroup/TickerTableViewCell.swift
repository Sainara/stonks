//
//  TickerTableViewCell.swift
//  stonks
//
//  Created by Artem Meloyan on 3/22/21.
//

import SwiftDate
import UIKit

class TickerTableViewCell: UITableViewCell {
    
    func configure(with ticket: TicketResponseWithDelta) {
        subviews.forEach({$0.removeFromSuperview()})
        
        backgroundColor = .clear
        
        let coreStack = UIStackView()
        coreStack.axis = .vertical
        coreStack.spacing = 10
        coreStack.isLayoutMarginsRelativeArrangement = true
        coreStack.layoutMargins = .allSides(10)
        addSubview(coreStack)
        //coreStack.setBackgroundColor(color: .lightBlack, raduis: 10)
        coreStack.fillSuperview(padding: .init(top: 7, left: 10, bottom: 7, right: 10))
        
//        snp.makeConstraints { (make) in
//            make.height.equalTo(100)
//        }
        
        let title = UILabel(text: ticket.ticket.company, font: Fonts.standart.gilroyMedium(ofSize: 23), textColor: .white, textAlignment: .left, numberOfLines: 2)
        coreStack.addArrangedSubview(title)
        coreStack.setCustomSpacing(7, after: title)
    
//        let subTitle = UILabel(text: mix.description, font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .white, textAlignment: .left, numberOfLines: 2)
//        coreStack.addArrangedSubview(subTitle)
        let tastes = ticket.ticket.price
        
        let tastedLbl = UILabel(text: "\(tastes)$", font: Fonts.standart.gilroyMedium(ofSize: 15), textColor: .white, textAlignment: .left, numberOfLines: 1)
        coreStack.addArrangedSubview(tastedLbl)
        coreStack.setCustomSpacing(5, after: tastedLbl)
        
        let isIncrease = ticket.delta_value > 0
        
        let rating = "\(isIncrease ? "▲" : "▼") \(ticket.delta_value.rounded(toPlaces: 3))$ - \(ticket.delta_percent.rounded(toPlaces: 2))%"
        let ratingLbl = UILabel(text: rating, font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: isIncrease ? .greenColor : .redColor, textAlignment: .left, numberOfLines: 1)
        coreStack.addArrangedSubview(ratingLbl)
        
        let date = Date(milliseconds: ticket.added_at).toString(.dateTimeMixed(dateStyle: .medium, timeStyle: .short))
        let dateLbl = UILabel(text: date, font: Fonts.standart.gilroyMedium(ofSize: 13), textColor: .white, textAlignment: .left, numberOfLines: 1)
        coreStack.addArrangedSubview(dateLbl)
  

    }
}

//
//  FeedTableViewCell.swift
//  MixApp
//
//  Created by Ян Мелоян on 05.11.2020.
//

import Kingfisher
import UIKit

class FeedTableViewCell: UITableViewCell {
    
    func configure(with mix: Mix) {
        subviews.forEach({$0.removeFromSuperview()})
        
        backgroundColor = .clear
        
        let coreStack = UIStackView()
        coreStack.axis = .vertical
        coreStack.spacing = 10
        coreStack.isLayoutMarginsRelativeArrangement = true
        coreStack.layoutMargins = .allSides(15)
        addSubview(coreStack)
        //coreStack.setBackgroundColor(color: .lightBlack, raduis: 10)
        coreStack.fillSuperview(padding: .init(top: 7, left: 15, bottom: 7, right: 15))
        let imageView = UIImageView()
        coreStack.addSubview(imageView)
        imageView.kf.setImage(with: URL(string: mix.imageUrl))
        imageView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            //make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        //imageView.clipsToBounds = true
        imageView.contentMode = .center
        coreStack.layer.cornerRadius = 12
        coreStack.clipsToBounds = true
        
        let dimmer = UIView()
        coreStack.addSubview(dimmer)
        dimmer.backgroundColor = .black
        dimmer.alpha = 0.4
        dimmer.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
//        snp.makeConstraints { (make) in
//            make.height.equalTo(100)
//        }
        
        let title = UILabel(text: mix.name, font: Fonts.standart.gilroyMedium(ofSize: 23), textColor: .white, textAlignment: .left, numberOfLines: 2)
        coreStack.addArrangedSubview(title)
        coreStack.setCustomSpacing(7, after: title)
    
//        let subTitle = UILabel(text: mix.description, font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .white, textAlignment: .left, numberOfLines: 2)
//        coreStack.addArrangedSubview(subTitle)
        let tastes = mix.tabacos.compactMap({$0}).map({$0.tabaco.taste.joined(separator: " • ")}).joined(separator: " • ")
        
        let tastedLbl = UILabel(text: tastes, font: Fonts.standart.gilroyMedium(ofSize: 15), textColor: .white, textAlignment: .left, numberOfLines: 1)
        coreStack.addArrangedSubview(tastedLbl)
        
        let rating = "👍\(mix.likes) 👎\(mix.dislikes)"
        let ratingLbl = UILabel(text: rating, font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .white, textAlignment: .left, numberOfLines: 1)
        coreStack.addArrangedSubview(ratingLbl)
        
        
  

    }
}

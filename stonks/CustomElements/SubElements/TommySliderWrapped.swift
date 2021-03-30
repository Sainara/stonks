//
//  TommySliderWrapped.swift
//  MixApp
//
//  Created by Ян Мелоян on 17.11.2020.
//

import UIKit

class TommySliderWrapped:UIView {
    
    var value:Float = 0.0
    var valueLabel:UILabel
    
    weak var delegate:SliderDelegate?
    
    init() {
        valueLabel = UILabel(text: "0%", font: Fonts.standart.gilroySemiBoldName(ofSize: 24), textColor: .lightGray, textAlignment: .right, numberOfLines: 1)
        super.init(frame: .zero)
        
        backgroundColor = .lightBlack
        
        let slider = TommySlider()
        addSubview(slider)
        slider.fillSuperview(padding: .init(top: 10, left: 20, bottom: 10, right: 90))
        slider.addTarget(self, action: #selector(valueViewDidChange(_:)), for: .valueChanged)
        
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        //textField.delegate = self
    }
    
    @objc func valueViewDidChange(_ slider: UISlider) {
        value = slider.value
        valueLabel.text = "\(Int(value * 100))%"
        print(value)
        delegate?.newValue(value: value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

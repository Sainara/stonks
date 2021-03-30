//
//  InfoLabel.swift
//  stonks
//
//  Created by Artem Meloyan on 1/12/21.
//

import UIKit

class InfoLabel: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 19)
        label.textColor = .white
        
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 23)
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var secondValueLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 23)
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var leftVStack: UIStackView = {
        let vStack = UIStackView()
        
        vStack.axis = .vertical
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subTitleLabel)
        
        return vStack
    }()
    
    lazy var rightVStack: UIStackView = {
        let vStack = UIStackView()
        
        vStack.axis = .vertical
        vStack.addArrangedSubview(valueLabel)
        vStack.addArrangedSubview(secondValueLabel)
        
        return vStack
    }()

    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        subTitleLabel.text = subtitle
        
        valueLabel.text = "-"
        
        setupView()
        
        //heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let hStack = UIStackView()
        
        hStack.addArrangedSubview(leftVStack)
        hStack.addArrangedSubview(rightVStack)
        
        addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        hStack.layoutMargins = .init(top: 10, left: 20, bottom: 10, right: 20)
        hStack.isLayoutMarginsRelativeArrangement = true
        
    }
    
    func update(with value: String, _ tag: Int) {
        setValue(value: value, tag: tag)
    }
    
    func reset() {
        setValue(value: "", tag: tag)
    }
    
    func setValue(value: String, tag: Int) {
        switch tag {
        case 0:
            valueLabel.text = value
        default:
            secondValueLabel.text = value
        }
    }
    
}

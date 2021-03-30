//
//  TommyTextViewWrapped.swift
//  MixApp
//
//  Created by Ян Мелоян on 17.11.2020.
//

import UIKit

class TommyTextViewWrapped:UIView {
    
    var value = ""
    
    weak var delegate:TextInputDelegate?
    
    let textField = TommyTextView()
    
    init(placeholder:String) {
        super.init(frame: .zero)
        
        backgroundColor = .lightBlack
        
        
        addSubview(textField)
        textField.fillSuperview(padding: .init(top: 10, left: 20, bottom: 10, right: 20))
        textField.placeholder = placeholder
        textField.placeholderColor = .lightGray
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.font = Fonts.standart.gilroyMedium(ofSize: 17)
        textField.tintColor = .white
        textField.delegate = self
        
        snp.makeConstraints { (make) in
            make.height.equalTo(100)
        }
    }
    
    func setText(value:String) {
        textField.text = value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TommyTextViewWrapped: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        value = textView.text ?? ""
        delegate?.textChanged(text: value)
    }
}

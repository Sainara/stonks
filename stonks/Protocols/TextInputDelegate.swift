//
//  TextInputDelegate.swift
//  MixApp
//
//  Created by Ян Мелоян on 17.11.2020.
//

import Foundation

protocol TextInputDelegate: class {
    func textChanged(text:String)
    func textBeginEditing()
    func rightImageClicked()
}

extension TextInputDelegate {
    func textChanged(text:String) {}
    func textBeginEditing() {}
    func rightImageClicked() {}
}

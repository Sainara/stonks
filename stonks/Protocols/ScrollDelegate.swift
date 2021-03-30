//
//  ScrollDelegate.swift
//  MixApp
//
//  Created by Ян Мелоян on 10.11.2020.
//

import UIKit

protocol ScrollDelegate: AnyObject {
    func scrollToView(view: UIView)
}

extension ScrollDelegate {
    func scrollToView(view: UIView) {}
}

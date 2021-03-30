//
//  TommyViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 12.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import NVActivityIndicatorView
import UIKit
import SnapKit

class TommyViewController: UIViewController {
    
    var bottomConstraint: Constraint? = nil
    var bottomOffset: CGFloat = 0.0
    var bottomPaddinng: CGFloat = 0.0
    
    let loadingIndicator = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .coreBlack
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: title ?? "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: Fonts.standart.gilroySemiBoldName(ofSize: 16)], for: .normal)
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.center.equalTo(view)
        }
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomConstraint?.update(offset: -keyboardHeight + view.safeAreaInsets.bottom - bottomPaddinng)
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
            }
        }
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        
        bottomConstraint?.update(offset: bottomOffset)
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            
        }
    }
    
    func showLoading(_ isShow: Bool) {
        loadingIndicator.isHidden = !isShow
    }
}

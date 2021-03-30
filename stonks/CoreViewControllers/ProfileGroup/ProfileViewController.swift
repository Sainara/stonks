//
//  ProfileViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 15.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class ProfileViewController: TommyStackViewController {
    
    lazy var loadingAlert = UIAlertController(style: .loading)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if App.shared.isNeedUpdateProfile {
            reload()
            App.shared.isNeedUpdateProfile = false
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        
        //view.backgroundColor = .white
        stackView.layoutMargins = .allSides(20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        navigationItem.title = "Профиль"
        navigationItem.largeTitleDisplayMode = .always
        
        initView()
        
        updateMe()
    }
    
    func updateMe() {
        AuthService.main.getMe { (result) in
            if result {
                self.reload()
            }
        }
    }
    
    func initView() {
        guard App.shared.user != nil else {
            setupViewWithState(state: .notAuth)
            return
        }
        setupViewWithState(state: .auth)
    }
    
    func setupViewWithState(state:ProfileState) {
        switch state {
        case .notAuth:
            setupNonAuth()
        case .auth:
            setupAuthView()
        }
    }
    
    func setupNonAuth() {
        let authWaysView = AuthWaysView()
        authWaysView.authDelegate = self
        addWidthArrangedSubView(view: authWaysView)
    }
    
    func setupAuthView() {
        guard let user = App.shared.user else {
            return
        }
        
        let userName = UILabel(text: user.name, font: Fonts.standart.gilroyMedium(ofSize: 30), textColor: .white, textAlignment: .center, numberOfLines: 0)
        stackView.addArrangedSubview(userName)
        
        let exitButton = TommyButton(text: "Выйти", style: .exit)
        exitButton.addOnTapTarget {
            App.shared.logOut()
            self.reload()
        }
        addWidthArrangedSubView(view: exitButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum ProfileState {
        case auth, notAuth
    }
}

extension ProfileViewController: AuthResultDelegate {
    func complete(isSuccess: Bool) {
        loadingAlert.dismiss(animated: true, completion: nil)
        if isSuccess {
            updateMe()
        }
    }
    
    func started() {
        self.present(loadingAlert, animated: true, completion: nil)
    }
}

extension ProfileViewController: ReloadProtocol {
    func reload() {
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        initView()
    }
}

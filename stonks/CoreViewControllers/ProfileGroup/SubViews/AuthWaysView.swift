//
//  AuthWaysView.swift
//  MixApp
//
//  Created by Ян Мелоян on 04.11.2020.
//

import AuthenticationServices
import LBTATools
import UIKit

class AuthWaysView: UIView {
    
    var authDelegate:AuthResultDelegate?
    var isNeedReload = true
    
    init() {
        super.init(frame: .zero)
    
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        let text = "Чтобы отслеживать стоимость акций нужно авторизоваться"
        
        let core = stack(UILabel(text: text, font: .systemFont(ofSize: 15, weight: .medium), textColor: .lightGray, textAlignment: .center, numberOfLines: 0),  spacing: 20, alignment: .fill, distribution: .fill)
        
        addSubview(core)
        core.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        if #available(iOS 13.0, *) {
            let authWithApple = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
            authWithApple.addHaptic(.impact(.light), forControlEvents: .touchUpInside)
            authWithApple.cornerRadius = 12
            authWithApple.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAppleAuth(sender:))))
            authWithApple.snp.makeConstraints { (make) in
                make.height.equalTo(55)
            }
            core.addArrangedSubview(authWithApple)
            core.setCustomSpacing(10, after: authWithApple)
        }
    }
    
    @available(iOS 13.0, *)
    @objc func didTapAppleAuth(sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
                    
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

@available(iOS 13.0, *)

extension AuthWaysView: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        return (vc?.view.window!)!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("credentials not found....")
            return
        }
        
        let identityToken = String(data: credentials.authorizationCode!, encoding: .utf8)!

        let fullname = "\(credentials.fullName?.nickname ?? "")"
        print(credentials.user)
        print(identityToken)
        print(fullname)
        
        self.authDelegate?.started()
        AuthService.main.authWithApple(token: identityToken, userName: fullname, email: credentials.email ?? "no_mail") { (result) in
            App.shared.isNeedUpdateProfile = true
            self.authDelegate?.complete(isSuccess: result)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
}

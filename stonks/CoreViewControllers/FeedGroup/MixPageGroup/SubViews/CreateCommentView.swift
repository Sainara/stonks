//
//  CreateCommentView.swift
//  MixApp
//
//  Created by Ян Мелоян on 08.11.2020.
//

import UIKit

class CreateCommentView: UIView {
    
    let coreStack = UIStackView()
    
    let mix:Mix
    
    var parentView:ReloadProtocol?
    var parentViewController:UIViewController?
    var scrollDelegate:ScrollDelegate?
    
    let tommyTextField = TommyTextField(placehldr: "Ваш комментарий...")
    let sendButton = UIButton(title: "", titleColor: .white, backgroundColor: .coreBlue)
    
    let activityView = UIActivityIndicatorView(style: .white)
    
    init(mix:Mix) {
        self.mix = mix
        
        super.init(frame: .zero)
        
        backgroundColor = .lightBlack

        addSubview(coreStack)
        coreStack.fillSuperview(padding: .init(top: 10, left: 15, bottom: 10, right: 15))
        
        coreStack.axis = .horizontal
        coreStack.spacing = 25
        coreStack.distribution = .fill
        coreStack.alignment = .fill
        
        setupView()
    }
    
    func setupView() {
        coreStack.addArrangedSubview(tommyTextField)
        sendButton.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(35)
        }
        
        sendButton.isEnabled = false
        
        sendButton.layer.cornerRadius = 35/2
        sendButton.tintColor = .white
        sendButton.isHaptic = true
        sendButton.setImage(UIImage(imageLiteralResourceName: "send"), for: .normal)
        sendButton.imageView?.setImageColor(color: .white)
        sendButton.imageView?.snp.makeConstraints({ (make) in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.center.equalToSuperview()
        })
        
        sendButton.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.snp.makeConstraints({ (make) in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.center.equalToSuperview()
        })
        activityView.stopAnimating()
        
        
        sendButton.addTarget(self, action: #selector(sendTapped(sender:)), for: .touchUpInside)
        
        tommyTextField.addTarget(self, action: #selector(textFieldChanged(textField:)), for: .editingChanged)
        tommyTextField.addTarget(self, action: #selector(textFieldBeginEdit(textField:)), for: .editingDidBegin)
        
        coreStack.addArrangedSubview(sendButton)
    }
    
    func presentAuth() {
        let controller = ProfileViewController()

        let detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: parentViewController!, to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        
        parentViewController?.present(controller, animated: true, completion: nil)
    }
    
    @objc func sendTapped(sender: UIButton) {
        guard let text = tommyTextField.text, !text.isEmpty else {
            return
        }
        if App.shared.user == nil {
            presentAuth()
            return
        }
        activityView.startAnimating()
        sendButton.imageView?.alpha = 0
        CommentsService.main.createComment(comment: text, mixID: "\(mix.id)") { [self] (result) in
            CommentsService.main.getComments(mixID: "\(mix.id)") { (result) in
                activityView.stopAnimating()
                tommyTextField.text = ""
                sendButton.imageView?.alpha = 1
                sendButton.isEnabled = false
                
                switch result {
                case .success(let data):
                    mix.comments = data
                case .failure(let error):
                    print(error)
                }
                
                parentView?.reload()
            }
        }
    }
    
    @objc private func textFieldBeginEdit(textField: UITextField) {
        print("######")
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.scrollDelegate?.scrollToView(view: textField)
        //}
    }
    
    @objc private func textFieldChanged(textField: UITextField) {
        sendButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

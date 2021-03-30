//
//  MixInfoView.swift
//  MixApp
//
//  Created by Ян Мелоян on 08.11.2020.
//

import UIKit

class MixInfoView: UIView {
    
    let mix:Mix

    weak var parentViewController:UIViewController?
    
    let likeButton = TommyButton(text: "👍")
    let dislikeButton = TommyButton(text: "👎")
    
    init(mix:Mix) {
        self.mix = mix
        
        super.init(frame: .zero)
        
        let coreStack = UIStackView()
        addSubview(coreStack)
        coreStack.fillSuperview()
        
        coreStack.isLayoutMarginsRelativeArrangement = true
        coreStack.axis = .vertical
        coreStack.layoutMargins = .allSides(15)
        coreStack.spacing = 25
        coreStack.distribution = .fill
        coreStack.alignment = .fill
        
        
        let title = UILabel(text: mix.name, font: Fonts.standart.gilroySemiBoldName(ofSize: 35), textColor: .white, textAlignment: .left, numberOfLines: 0)
        coreStack.addArrangedSubview(title)
        coreStack.setCustomSpacing(5, after: title)
        
        let desc = UILabel(text: mix.description, font: Fonts.standart.gilroyMedium(ofSize: 19), textColor: .lightGray, textAlignment: .left, numberOfLines: 0)
        coreStack.addArrangedSubview(desc)
        
        let ingrTitle = UILabel(text: "Ингридиенты", font: Fonts.standart.gilroySemiBoldName(ofSize: 23), textColor: .white, textAlignment: .left, numberOfLines: 0)
        coreStack.addArrangedSubview(ingrTitle)
        coreStack.setCustomSpacing(3, after: ingrTitle)
        
        var maxPercWidth: CGFloat = 0
        
        for ingridient in mix.tabacos {
            maxPercWidth = max(maxPercWidth, "\(ingridient.percentage)%".widthOfString(usingFont: Fonts.standart.gilroySemiBoldName(ofSize: 27)) + 5)
        }
        
        for (index, ingridient) in mix.tabacos.enumerated() {
            let view = IngridientView(ingridient: ingridient, width: maxPercWidth)
            coreStack.addArrangedSubview(view)
            if index < mix.tabacos.count - 1 {
                coreStack.setCustomSpacing(0, after: view)
            }
        }
        
        let instrTitle = UILabel(text: "Инструкция", font: Fonts.standart.gilroySemiBoldName(ofSize: 23), textColor: .white, textAlignment: .left, numberOfLines: 0)
        coreStack.addArrangedSubview(instrTitle)
        coreStack.setCustomSpacing(5, after: instrTitle)
        
        let instrDesc = UILabel(text: mix.instruction, font: Fonts.standart.gilroyMedium(ofSize: 18), textColor: .white, textAlignment: .left, numberOfLines: 0)
        coreStack.addArrangedSubview(instrDesc)
        
        likeButton.setTitle("👍 \(mix.likes)", for: .normal)
        likeButton.addOnTapTarget { [self] in
            if let user = App.shared.user {
                print(user)
                App.shared.isNeedReloadFeedData = true
                
                if user.dislikedMixes.contains(mix.id) {
                    MixService.main.voteMix(mixId: String(mix.id), isLike: false, isRemove: !user.dislikedMixes.contains(mix.id)) { (res) in
                        if res {
                            if user.dislikedMixes.contains(mix.id) {
                                user.dislikedMixes.remove(mix.id)
                                dislikeButton.setBackgroundColor(color: .bgColor, forState: .normal)
                                mix.dislikes -= 1
                                dislikeButton.setTitle("👎 \(mix.dislikes)", for: .normal)
                                MixService.main.voteMix(mixId: String(mix.id), isLike: true, isRemove: !user.likedMixes.contains(mix.id)) { (res) in
                                    print(res)
                                    if res {
                                        if user.likedMixes.contains(mix.id) {
                                            user.likedMixes.remove(mix.id)
                                            mix.likes -= 1
                                            likeButton.setTitle("👍 \(mix.likes)", for: .normal)
                                            likeButton.setBackgroundColor(color: .bgColor, forState: .normal)

                                        } else {
                                            user.likedMixes.insert(mix.id)
                                            mix.likes += 1
                                            likeButton.setTitle("👍 \(mix.likes)", for: .normal)
                                            likeButton.setBackgroundColor(color: .greenColor, forState: .normal)
                                        }
                                    }
                                }
                            }
                        }
                        print(res)
                    }
                } else {
                    MixService.main.voteMix(mixId: String(mix.id), isLike: true, isRemove: !user.likedMixes.contains(mix.id)) { (res) in
                        print(res)
                        if res {
                            if user.likedMixes.contains(mix.id) {
                                user.likedMixes.remove(mix.id)
                                mix.likes -= 1
                                likeButton.setTitle("👍 \(mix.likes)", for: .normal)
                                likeButton.setBackgroundColor(color: .bgColor, forState: .normal)

                            } else {
                                user.likedMixes.insert(mix.id)
                                mix.likes += 1
                                likeButton.setTitle("👍 \(mix.likes)", for: .normal)
                                likeButton.setBackgroundColor(color: .greenColor, forState: .normal)
                            }
                        }
                    }
                }
            } else {
                presentAuth()
            }
        }
        dislikeButton.setTitle("👎 \(mix.dislikes)", for: .normal)
        dislikeButton.addOnTapTarget { [self] in
            if let user = App.shared.user {
                print(user)
                App.shared.isNeedReloadFeedData = true
                
                if user.likedMixes.contains(mix.id) {
                    MixService.main.voteMix(mixId: String(mix.id), isLike: true, isRemove: !user.likedMixes.contains(mix.id)) { (res) in
                        print(res)
                        if res {
                            if user.likedMixes.contains(mix.id) {
                                user.likedMixes.remove(mix.id)
                                mix.likes -= 1
                                likeButton.setTitle("👍 \(mix.likes)", for: .normal)
                                likeButton.setBackgroundColor(color: .bgColor, forState: .normal)
                                MixService.main.voteMix(mixId: String(mix.id), isLike: false, isRemove: !user.dislikedMixes.contains(mix.id)) { (res) in
                                    if res {
                                        if user.dislikedMixes.contains(mix.id) {
                                            user.dislikedMixes.remove(mix.id)
                                            mix.dislikes -= 1
                                            dislikeButton.setTitle("👎 \(mix.dislikes)", for: .normal)
                                            dislikeButton.setBackgroundColor(color: .bgColor, forState: .normal)
                                        } else {
                                            user.dislikedMixes.insert(mix.id)
                                            mix.dislikes += 1
                                            dislikeButton.setTitle("👎 \(mix.dislikes)", for: .normal)
                                            dislikeButton.setBackgroundColor(color: .redColor, forState: .normal)
                                        }
                                    }
                                    print(res)
                                }
                            }
                        }
                    }
                } else {
                    MixService.main.voteMix(mixId: String(mix.id), isLike: false, isRemove: !user.dislikedMixes.contains(mix.id)) { (res) in
                        if res {
                            if user.dislikedMixes.contains(mix.id) {
                                user.dislikedMixes.remove(mix.id)
                                mix.dislikes -= 1
                                dislikeButton.setTitle("👎 \(mix.dislikes)", for: .normal)
                                dislikeButton.setBackgroundColor(color: .bgColor, forState: .normal)
                            } else {
                                user.dislikedMixes.insert(mix.id)
                                mix.dislikes += 1
                                dislikeButton.setTitle("👎 \(mix.dislikes)", for: .normal)
                                dislikeButton.setBackgroundColor(color: .redColor, forState: .normal)
                            }
                        }
                        print(res)
                    }
                }
                
                
            } else {
                presentAuth()
            }
        }
        
        
        if let user = App.shared.user {
            if user.likedMixes.contains(mix.id) {
                likeButton.setTitleColor(.white, for: .normal)
                likeButton.setBackgroundColor(color: .greenColor, forState: .normal)
            }
            if user.dislikedMixes.contains(mix.id) {
                dislikeButton.setTitleColor(.white, for: .normal)
                dislikeButton.setBackgroundColor(color: .redColor, forState: .normal)
            }
        }

        let stack = UIView()
        let a = hstack(likeButton, dislikeButton, spacing: 15)
        stack.addSubview(a)
        a.fillSuperview()
        coreStack.addArrangedSubview(stack)
        coreStack.setCustomSpacing(15, after: stack)
        
        likeButton.snp.makeConstraints { (make) in
            make.width.equalTo(dislikeButton)
        }
        
        var isContain = false
        
        if let user = App.shared.user, user.favedMixes.contains(mix) {
            isContain = true
        }
        
        let addToFavButton = TommyButton(text: isContain ? "- Удалить из избранного" : "+ Добавить в избранное", style: .secondary)
        
        coreStack.addArrangedSubview(addToFavButton)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func presentAuth() {
        let controller = ProfileViewController()

        let detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: parentViewController!, to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        
        parentViewController?.present(controller, animated: true, completion: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

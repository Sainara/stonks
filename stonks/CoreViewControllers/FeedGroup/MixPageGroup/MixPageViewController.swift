//
//  MixPageViewController.swift
//  MixApp
//
//  Created by Ян Мелоян on 08.11.2020.
//

import UIKit

class MixPageViewController: TommyStackViewController {
    
    let mix:Mix
    let commentsView:CommentsView
    let createCommnentView:CreateCommentView
    let infoStack:MixInfoView
    
    
    init(mix:Mix) {
        self.mix = mix
        self.infoStack = MixInfoView(mix: mix)
        self.createCommnentView = CreateCommentView(mix: mix)
        self.commentsView = CommentsView(mix: mix)
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.largeTitleDisplayMode = .never
        
        setupView()
    }
    
    private func setupView() {
        
        infoStack.parentViewController = self
        addWidthArrangedSubView(view: infoStack, spacing: 20, offsets: 0)
                
        createCommnentView.parentView = self
        createCommnentView.scrollDelegate = self
        createCommnentView.parentViewController = self
        addWidthArrangedSubView(view: createCommnentView, spacing: 10, offsets: 0)
        
        addWidthArrangedSubView(view: commentsView, spacing: 20, offsets: 0)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MixPageViewController: ReloadProtocol {
    func reload() {
        commentsView.reload()
    }
}

extension MixPageViewController: ScrollDelegate {
    func scrollToView(view: UIView) {
        scrollView.scrollToView(view: view, animated: true)
    }
}

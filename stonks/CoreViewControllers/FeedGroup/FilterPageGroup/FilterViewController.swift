//
//  FilterViewController.swift
//  MixApp
//
//  Created by Ян Мелоян on 20.12.2020.
//

import UIKit

class FilterViewController: TommyStackViewController {
    
    var optionViews: [FilterElementView] = []
    var savedOptionViews: [FilterElementView] = []
        
    var isDismissAfterClick = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDismissAfterClick = false
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        //view.backgroundColor = .white
        stackView.layoutMargins = .allSides(20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        bottomOffset = 170
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let title = UILabel(text: "Фильтры", font: Fonts.standart.gilroySemiBoldName(ofSize: 27), textColor: .white, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: title)
        
        addFilters()
        
        let but = TommyButton(text: "Применить", style: .secondary)
        view.addSubview(but)
        but.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        but.addOnTapTarget { [weak self] in
            let selectedOptions = self?.optionViews.flatMap({$0.options}).filter({$0.isSelected})
            self?.isDismissAfterClick = true
            if let self = self {
                self.savedOptionViews = self.optionViews

            }
            self?.dismiss(animated: true) {}
        }
        
        let close = UIButton(title: "Сбросить", titleColor: .white)
        close.titleLabel?.font = Fonts.standart.gilroyMedium(ofSize: 15)
        close.contentHorizontalAlignment = .trailing
        view.addSubview(close)
        close.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        close.addTarget(self, action: #selector(resetBut), for: .touchUpInside)
    }
    
    func addFilters() {
        let tasteFilter = FilterElementView(name: "Вкус", type: .taste)
        tasteFilter.parentViewController = self
        addWidthArrangedSubView(view: tasteFilter)
        optionViews.append(tasteFilter)

        let producerFilter = FilterElementView(name: "Производитель", type: .producer)
        producerFilter.parentViewController = self
        addWidthArrangedSubView(view: producerFilter)
        optionViews.append(producerFilter)
        
        savedOptionViews = optionViews
    }
    
    func makeFiltersWithSaved() {
        savedOptionViews.forEach({addWidthArrangedSubView(view: $0)})
    }
    
    @objc func resetBut() {
        isDismissAfterClick = true
        reload()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        if !isDismissAfterClick {
            optionViews = savedOptionViews
            makeFiltersWithSaved()
        }
    }
}

extension FilterViewController: ReloadProtocol {
    func reload() {
        optionViews.forEach({$0.removeFromSuperview()})
        optionViews = []
        savedOptionViews = []
        addFilters()
    }
}

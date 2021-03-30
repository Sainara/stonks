//
//  FilterElementView.swift
//  MixApp
//
//  Created by Ян Мелоян on 20.12.2020.
//

import UIKit

class FilterElementView: UIView {
    
    let name: String
    let type: FilterOptionType
    
    var options: [FilterOptionItem] = []
    
    weak var parentViewController:UIViewController?
    
    var selector:FilterSelectorView!
    
    init(name:String, type: FilterOptionType) {
        self.name = name
        self.type = type
        
        super.init(frame: .zero)
        
        setupView()
        
        SearchAndFilterService.main.getSearchOptions(type: type) { [weak self] (result) in
            switch result {
            case .success(let vals):
                self?.options = vals
            case .failure(let error):
                print(error)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        let coreStack = UIStackView()
        addSubview(coreStack)
        coreStack.fillSuperview()
        coreStack.axis = .vertical
        coreStack.spacing = 7
        
        let title = UILabel(text: name, font: Fonts.standart.gilroyRegular(ofSize: 17), textColor: .white, textAlignment: .left, numberOfLines: 1)
        coreStack.addArrangedSubview(title)
        
        selector = makeSelectorView()
        coreStack.addArrangedSubview(selector)
        
        
    }
    
    @objc func tapped() {
        var title:String?
        switch type {
        case .taste:
            title = "Вкус"
        case .producer:
            title = "Производитель"
        }
        parentViewController?.present(makeOptionsViewController().wrapInNavigationController(with: title), animated: true, completion: nil)
    }
}

private extension FilterElementView {
    func makeSelectorView() -> FilterSelectorView {
        let view = FilterSelectorView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tap)
        
        return view
    }
    
    func makeOptionsViewController() -> FilterOptionTableViewController {
        let vc = FilterOptionTableViewController(options: options)
        vc.delegate = self
        return vc
    }
}

extension FilterElementView: FilterOptionTableViewControllerDelegate {
    func didUpdated(options:[FilterOptionItem]) {
        self.options = options
        selector.title.text = options.filter({$0.isSelected}).map({$0.name}).joined(separator: ", ")
        
        if selector.title.text == "" {
            selector.title.text = "Выберите"
        }
    }
}

class FilterSelectorView: UIView {
    
    lazy var title = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        title = UILabel(text: "Выберите", font: Fonts.standart.gilroyRegular(ofSize: 17), textColor: .white, textAlignment: .left, numberOfLines: 1)
        
        addSubview(title)
        title.fillSuperview(padding: .allSides(10))
        
        layer.cornerRadius = 7
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func updateTitle(with value: String) {
        title.text = value
    }
}

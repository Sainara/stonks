//
//  FeedViewController.swift
//  MixApp
//
//  Created by Ян Мелоян on 04.11.2020.
//

import UIKit

class FeedViewController: TommyViewController {
    
    let tableView = UITableView()
    let refresher = UIRefreshControl()
    
    var mixes:[Mix] = []
    
    let buts = UIImageView(image: UIImage(imageLiteralResourceName: "filter"))
    
    let cellID = "mixCell"

    let filterController = FilterViewController()
    
    var savedOptions: [FilterOptionItem] = []
    
    let emptyLabel = UILabel(text: "Ничего не найдено", font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .lightGray, textAlignment: .center, numberOfLines: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if App.shared.isNeedReloadFeedData {
            tableView.reloadData()
            App.shared.isNeedReloadFeedData = false
        }
        //App.shared.user = User(name: "Andrew Staroverov")//
        //print(mixes.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        buts.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        buts.setImageColor(color: .gray)
        
        let optionsGest = UITapGestureRecognizer(target: self, action: #selector(showOptions))
        buts.isUserInteractionEnabled = true
        buts.addGestureRecognizer(optionsGest)
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        emptyLabel.isHidden = true
//        if #available(iOS 13.0, *) {
//            print(searchController.searchBar.constraints)
//            print(searchController.searchBar.searchTextField.constraints)
//            searchController.searchBar.searchTextField.addSubview(buts)
//            buts.snp.makeConstraints { (make) in
//                make.centerY.equalToSuperview()
//                make.trailing.equalToSuperview().offset(-10)
//            }
//print(searchController.searchBar.searchTextField.rightAnchor)           // searchController.searchBar.searchTextField.rightView = buts
//
//        } else {
//            // Fallback on earlier versions
//        }
//        print("!!!!!!!!!")
//        print(searchController.searchBar.subviews[0].subviews[1].subviews[0])
//        print((searchController.searchBar.subviews[0].subviews[1].subviews[0] as! UITextField).font = Fonts.standart.gilroyMedium(ofSize: 17))
//        print((searchController.searchBar.subviews[0].subviews[1].subviews[0] as! UITextField).tintColor = .red)
        //searchController.searchBar.subviews[0].subviews[1].subviews[0].addSubview(buts)
        //print(searchController.searchBar.subviews[0].subviews[1].subviews[0])
//        buts.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.trailing.equalToSuperview().offset(-10)
//        }
        //searchController.searchBar.showsCancelButton = false
        //searchController.searchBar.ca/
        // 4
        
        // 5
        definesPresentationContext = true
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        
        //view.backgroundColor = .white
        navigationItem.title = "Лента"
        navigationItem.largeTitleDisplayMode = .always
        
        initView()
        
        getMixes()
    }
    
    func initView() {
        view.addSubview(tableView)
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.fillSuperview()
        
        refresher.tintColor = .bgColor
        refresher.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
    }
    
    func getMixes() {
        beforeReq()
        MixService.main.getMixes { [weak self] (result) in
            self?.applyNewMixes(result: result)
        }
    }
    
    func getFilteredMixes(options:[FilterOptionItem]) {
        beforeReq()
    }
    
    func beforeReq() {
        showLoading(true)
        emptyLabel.isHidden = true
    }
    
    func applyNewMixes(result: Result<[Mix], NetworkError>) {
        switch result {
        case .success(let data):
            self.mixes = data
            self.tableView.reloadData()
            self.emptyLabel.isHidden = !data.isEmpty
            
        case .failure(let error):
            print(error)
            break
        }
        self.showLoading(false)
        self.refresher.endRefreshing()
    }
    
    func presentFilterView() {
        let detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: filterController)
        filterController.modalPresentationStyle = .custom
        filterController.transitioningDelegate = detailsTransitioningDelegate
        
        self.present(filterController, animated: true, completion: nil)
    }
    
    @objc func refresh(sender:AnyObject){
        getFilteredMixes(options: savedOptions)
    }
    
    @objc private func showOptions(sender:AnyObject){
        presentFilterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mixes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FeedTableViewCell
        
        cell.configure(with: mixes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mixPage = MixPageViewController(mix: mixes[indexPath.row])
        navigationController?.pushViewController(mixPage, animated: true)
    }
}

extension FeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getFilteredMixes(options: savedOptions)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        getFilteredMixes(options: [])
//        if #available(iOS 13.0, *) {
//            if searchBar.responds(to: Selector(("setContentInset:"))) {
//                let aSelector = Selector(("setContentInset:"))
//                let anInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 35)
//               searchBar.perform(aSelector, with: anInset)
//                print("#######")
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//        if searchText.isEmpty {
//            UIView.animate(withDuration: 0.2) {
//                self.buts.snp.updateConstraints { (make) in
//                    make.trailing.equalToSuperview().offset(-10)
//                }
//                self.buts.layoutIfNeeded()
//            }
//        } else {
//            UIView.animate(withDuration: 0.2) {
//                self.buts.snp.updateConstraints { (make) in
//                    make.trailing.equalToSuperview().offset(-30)
//                }
//                self.buts.layoutIfNeeded()
//            }
//
//        }
    }
}

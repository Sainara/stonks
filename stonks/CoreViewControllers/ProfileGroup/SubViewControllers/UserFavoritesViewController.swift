//
//  UserFavoritesViewController.swift
//  MixApp
//
//  Created by Ян Мелоян on 14.11.2020.
//

import UIKit

class UserFavoritesViewController: TommyViewController {
    
    let tableView = UITableView()
    //let refresher = UIRefreshControl()
    
    var mixes:[Mix] = []
    
    let cellID = "mixCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if App.shared.isNeedUpdateFavs {
            if let user = App.shared.user {
                mixes = Array(user.favedMixes)
            }
            tableView.reloadData()
            App.shared.isNeedUpdateFavs = false
        }
        //App.shared.user = User(name: "Andrew Staroverov")//
        //print(mixes.count)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        
        //view.backgroundColor = .white
        navigationItem.title = "Избранное"
        navigationItem.largeTitleDisplayMode = .always
        
        initView()
    }
    
    func initView() {
        view.addSubview(tableView)
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.fillSuperview()
        
        if let user = App.shared.user {
            mixes = Array(user.favedMixes)
            tableView.reloadData()
        }
        
//        refresher.tintColor = .bgColor
//        refresher.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//        tableView.addSubview(refresher)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
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

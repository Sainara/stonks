//
//  FavoritesViewController.swift
//  stonks
//
//  Created by Artem Meloyan on 2/8/21.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    var tickers: [String] = []
    
    let reuseIdentifier = "reuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkLayer.shared.getFavs { result in
            switch result {
            case .success(let data):
                self.tickers = data.tickers
                self.tableView.reloadData()
            case .failure( _):
                break
            }
        }
    }
}

extension FavoritesViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        
        cell.textLabel?.text = tickers[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tickers.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [.init(style: .destructive, title: "Удалить", handler: { [self] (action, indexPath) in
            NetworkLayer.shared.removeFromFavs(ticker: tickers[indexPath.row]) { _ in
                tickers.remove(at: tickers.firstIndex(of: tickers[indexPath.row])!)
                tableView.reloadData()
            }
        })]
    }
}

//
//  CreateMIxViewController.swift
//  MixApp
//
//  Created by Ян Мелоян on 17.11.2020.
//

import UIKit

class PortfelViewController: TommyViewController {
    
    var tableView: UITableView
    
    var tickers: [TicketResponseWithDelta] = []
    
    let cellID = "tickersCell"
    
    init() {
        tableView = UITableView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
        navigationItem.title = "Портфель"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TickerTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AuthService.main.getMe { (result) in
            self.tickers = App.shared.user?.favedTikers ?? []
            self.tableView.reloadData()
        }
    }
    
    func setupView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    
    func presentAuth() {
        let controller = ProfileViewController()

        let detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension PortfelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TickerTableViewCell

        cell.configure(with: tickers[indexPath.row]
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         
        navigationController?.pushViewController(TickerMainPage(ticker: tickers[indexPath.row]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [.init(style: .destructive, title: "Удалить", handler: { [self] (action, indexPath) in
            MixService.main.addToFav(company: tickers[indexPath.row].ticket.company, isRemove: true) { _ in
                tickers.remove(at: tickers.firstIndex(of: tickers[indexPath.row])!)
                tableView.reloadData()
            }
        })]
    }
}

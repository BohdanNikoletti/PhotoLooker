//
//  LookerHistoryTableViewController.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 29.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

final class LookerHistoryTableViewController: UITableViewController{
    
    //MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    fileprivate let unfilteredRequests = ["cat", "girls", "boys"].sorted()
    fileprivate var filterRequests: [String]?
    
    //MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Looker History"
        filterRequests = unfilteredRequests
        
        tableView.tableFooterView = UIView()
        
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "basicCell")
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let requests = filterRequests else {
            return 0
        }
        return requests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        if let requests = filterRequests {
            let request = requests[indexPath.row]
            cell.textLabel!.text = request
            cell.imageView?.image = UIImage(named: "empty")
        }
        return cell
    }
 
    //MARK: - TODO add as feature ASAP
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive{
            searchController.dismiss(animated: true, completion: nil)
        }
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController?.pushViewController(feedController, animated: true)
    }
}
extension LookerHistoryTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filterRequests = unfilteredRequests.filter { team in
                return team.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filterRequests = unfilteredRequests
        }
        tableView.reloadData()
    }

}

class HistoryCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        backgroundColor = UIColor.white
    }
}

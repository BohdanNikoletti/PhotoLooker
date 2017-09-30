//
//  LookerHistoryTableViewController.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 29.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

final class HistoryTableViewController: UITableViewController{
    
    //MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    fileprivate let unfilteredRequests = ["cat", "girls", "boys"].sorted()
    fileprivate var filterRequests: [String]?
    fileprivate var request: AnyObject?
    
    //MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Looker History"
        filterRequests = unfilteredRequests
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        
        tableView.tableFooterView = UIView()
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "basicCell")
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
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
        cell.accessoryType = .disclosureIndicator
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
        //MARK: - TODO change to ImageItem obj now is dummy
        let selectedRequest = unfilteredRequests[indexPath.row]
        loadImages(selectedRequest)
    }
    
    //MARK: - Private methods
    fileprivate func navigateToFeedController(withData loadedData: [ImageItem]){
        if searchController.isActive{
            searchController.dismiss(animated: true, completion: nil)
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.size.width/3, height: self.view.frame.size.width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let feedController = FeedController(collectionViewLayout: layout)
        feedController.items = loadedData
        self.navigationController?.pushViewController(feedController, animated: true)
    }
    fileprivate func loadImages(_ searchPhrase: String){
        let iamgesReqource = ImageResource(searchTo: searchPhrase)
        let imagesRequest = ApiRequest(resource: iamgesReqource)
        request = imagesRequest
        imagesRequest.load {
            [weak self] (imageItems: [ImageItem]?) in
            guard let items = imageItems,
                let firstItem = items.first
                else {
                    return //MARK: - TODO PROCESS EMPTY RESPONSE
            }
            print(firstItem)
            self?.navigateToFeedController(withData: items)
        }

    }
}
extension HistoryTableViewController: UISearchResultsUpdating, UISearchBarDelegate{
    
    //MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filterRequests = unfilteredRequests.filter {
                request in
                return request.lowercased().contains(searchText.lowercased())
            }
        } else {
            filterRequests = unfilteredRequests
        }
        tableView.reloadData()
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        loadImages(searchBarText)
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

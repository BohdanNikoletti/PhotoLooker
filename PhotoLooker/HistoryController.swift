//
//  LookerHistoryTableViewController.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 29.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class HistoryController: UITableViewController, NVActivityIndicatorViewable{
    
    //MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let cellId = "historyCell"
    fileprivate var requests = HistoryItem.getHistory()
    fileprivate var filteredRequests: [HistoryItem]!
    fileprivate var request: AnyObject?

    //MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = AppColors.secondaryLight

        tableView.separatorStyle = .singleLine
        settingUpCache()
        
        filteredRequests = requests

        navigationItem.title = "Looker History"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        
        tableView.tableFooterView = UIView()
        tableView.register(HistoryCell.self, forCellReuseIdentifier: cellId)
        
        settingUpSearchControl()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRequests.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HistoryCell else{
            fatalError("Unexpected cell! cann not cast to HistoryCell")
        }
        let historyItem = filteredRequests[indexPath.row]
        cell.historyItem = historyItem
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            HistoryItem.perform(operation: .delete, on: filteredRequests.remove(at: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .fade)
            requests = filteredRequests
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequest = filteredRequests[indexPath.row]
        let requestPhrase = selectedRequest.requestPhrase
        loadImages(requestPhrase)
    }
    
    //MARK: - Private methods
    private func settingUpCache(){
        let memoryCapacity = 30 * 512 * 512
        let dislCapacity = memoryCapacity
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: dislCapacity, diskPath: "PhotoLooker")
        URLCache.shared = urlCache
    }
    private func settingUpSearchControl(){
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    fileprivate func navigateToFeedController(withData loadedData: [ImageItem]){
        
        if searchController.isActive{
            searchController.dismiss(animated: true, completion: nil)
        }
        
        //Customize feed control layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.size.width/3, height: self.view.frame.size.width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let feedController = FeedController(collectionViewLayout: layout)
        feedController.items = loadedData
        self.navigationController?.pushViewController(feedController, animated: true)
    }
    fileprivate func loadImages(_ searchPhrase: String){
        searchController.searchBar.resignFirstResponder()
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Looking for \(searchPhrase) images...😉", type: NVActivityIndicatorType.orbit)
        
        let iamgesReqource = ImageResource(searchTo: searchPhrase)
        let imagesRequest = ApiRequest(resource: iamgesReqource)
        request = imagesRequest
        
        imagesRequest.load {
            [weak self] (imageItems: [ImageItem]?) in
            guard let items = imageItems,
                let firstItem = items.first
                else {
                        NVActivityIndicatorPresenter.sharedInstance.setMessage("Searching for \(searchPhrase) didn't give any results 😔")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                            self?.stopAnimating()
                        }
                return
            }
            self?.caсhe(item: firstItem, forPhrase: searchPhrase)
            self?.stopAnimating()
            self?.navigateToFeedController(withData: items)
        }
    }
    private func caсhe(item: ImageItem, forPhrase searchPhrase: String){
        
        //Load first image from request result
        let imageUrl = item.imageURL
        let imageReq = ImageRequest(url: imageUrl)
        request = imageReq
        
        imageReq.load(withCompletion: {
            [weak self] (image: UIImage?) in
            
            guard let image = image else {
                print("Error during saving history: no image to caсhe")
                return
            }
            
            // Save locally image and request data
            if let data = UIImageJPEGRepresentation(image, 0.5){
                
                let docDir = URL(fileURLWithPath: FileManager.getDocumentDirectory())
                let imageLocalURL = docDir.appendingPathComponent("\(item.id).jpg")
                
                let historyItem = HistoryItem()
                historyItem.imagePath = imageLocalURL.path
                historyItem.requestPhrase = searchPhrase.lowercased()
                HistoryItem.perform(operation: .add, on: historyItem)
                do{
                    if !FileManager.default.fileExists(atPath: imageLocalURL.path){
                        try data.write(to: imageLocalURL)
                    }
                }catch {
                    print("Caching history image error: \(error.localizedDescription)")
                }
                if (self?.requests.filter{ $0.requestPhrase == historyItem.requestPhrase})?.count == 0 {
                    self?.requests.append(historyItem)
                    self?.filteredRequests = self?.requests
                    self?.tableView.reloadData()
                }
            }
        })
    }
}

extension HistoryController: UISearchResultsUpdating, UISearchBarDelegate{
    
    //MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredRequests = requests.filter {
                request in
                return request.requestPhrase.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredRequests = requests
        }
        tableView.reloadData()
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        loadImages(searchBarText)
    }
}

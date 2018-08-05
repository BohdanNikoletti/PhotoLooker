//
//  LookerHistoryTableViewController.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 29.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class HistoryController: UITableViewController, NVActivityIndicatorViewable {
  
  // MARK: - Properties
  private let searchController = UISearchController(searchResultsController: nil)
  private let rowHeight: CGFloat = 80
  private let cellId = "historyCell"
  private var requests = HistoryItem.getHistory()
  private var filteredRequests: [HistoryItem] = []
  private var request: AnyObject?
  
  // MARK: - Lifecycle events
  override func viewDidLoad() {
    super.viewDidLoad()
    
    filteredRequests = requests
    
    settingUpTableView()
    settingUpSearchControl()
    settingUpSearchBar()
    settingUpNavigationItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    URLCache.shared.removeAllCachedResponses()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  // MARK: - Table view data source & delegate
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredRequests.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return rowHeight
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HistoryCell else {
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
  
  // MARK: - Private methods
  private func settingUpNavigationItem() {
    navigationItem.title = "Looker History"
    navigationItem.backBarButtonItem = UIBarButtonItem(
      title: "", style: .plain, target: nil, action: nil)
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
  }
  
  private func settingUpTableView() {
    tableView.backgroundColor = AppColors.secondaryLight
    tableView.separatorStyle = .singleLine
    tableView.tableFooterView = UIView()
    tableView.register(HistoryCell.self, forCellReuseIdentifier: cellId)
  }
  
  private func settingUpSearchControl() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "What are you looking for?🧐"
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    
    definesPresentationContext = true

  }
  
  private func settingUpSearchBar() {
    let searchBar = searchController.searchBar
    searchBar.tintColor = UIColor.white
    searchBar.barTintColor = AppColors.primary
    searchBar.delegate = self
    (UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]))
      .defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
  }
  
  private func navigateToFeedController(withData loadedData: [ImageItem], requestPhrase: String) {

    //Customize feed control layout
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets.zero//(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = CGSize(width: view.frame.size.width/3,
                             height: view.frame.size.width/3)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    let feedController = FeedController(collectionViewLayout: layout,
                                        imagesResource: ImageResource(searchTo: requestPhrase))
    feedController.items = loadedData
    self.navigationController?.pushViewController(feedController, animated: true)
  }
  
  private func loadImages(_ searchPhrase: String) {
    
    searchController.searchBar.resignFirstResponder()
    let size = CGSize(width: 30, height: 30)
    startAnimating(size, message: "Looking for \(searchPhrase) images...😉",
      type: NVActivityIndicatorType.orbit)
    
    let imagesRequest = ApiRequest(resource: ImageResource(searchTo: searchPhrase))
    request = imagesRequest
    
    imagesRequest.load { [weak self] imageItems in
      guard let items = imageItems,
        let firstItem = items.first
        else {
          NVActivityIndicatorPresenter
            .sharedInstance
            .setMessage("Searching for \(searchPhrase) didn't give any results 😔")
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self?.stopAnimating()
          }
          return
      }
      self?.caсhe(item: firstItem, forPhrase: searchPhrase)
      self?.stopAnimating()
      self?.navigateToFeedController(withData: items, requestPhrase: searchPhrase)
    }
  }
  
  private func caсhe(item: ImageItem, forPhrase searchPhrase: String) {
    
    //Load first image from request result
    guard let imageUrl = item.imageURL else { return }
    let imageReq = ImageRequest(url: imageUrl)
    request = imageReq
    
    imageReq.load(withCompletion: { [unowned self] image in
      
      guard let image = image else {
        print("Error during saving history: no image to caсhe")
        return
      }
      
      // Save locally image and request data
      if let data = UIImageJPEGRepresentation(image, 0.5),
        let image = UIImage(data: data) {
        let key = ImageCachingService.Key.id(key: item.imageKey)
        ImageCachingService.shared.save(image: image, key: key)
        let historyItem = HistoryItem()
        historyItem.imagePath = item.imageKey
        historyItem.requestPhrase = searchPhrase.lowercased()
        HistoryItem.perform(operation: .add, on: historyItem)
        let historyItemsByPhrase = self.requests.filter({ $0.requestPhrase == historyItem.requestPhrase })
        if historyItemsByPhrase.isEmpty {
          self.requests.append(historyItem)
          self.filteredRequests = self.requests
          self.tableView.reloadData()
        }
      }
    })
  }
}

extension HistoryController: UISearchResultsUpdating, UISearchBarDelegate {
  
  // MARK: - UISearchResultsUpdating
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      filteredRequests = requests.filter {  request in
        return request.requestPhrase.lowercased().contains(searchText.lowercased())
      }
    } else {
      filteredRequests = requests
    }
    tableView.reloadData()
  }
  
  // MARK: - UISearchBarDelegate
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchBarText = searchBar.text else { return }
    loadImages(searchBarText)
  }
}

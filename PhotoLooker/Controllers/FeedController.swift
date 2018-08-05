//
//  ViewController.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 29.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

final class FeedController: UICollectionViewController {
  
  // MARK: - Properties
  var items = [ImageItem]() {
    didSet {
      collectionView?.reloadData()
    }
  }
  private let cellId = "feedCell"
  private let footerReuseIdentifier = "footerView"
  private var imagesResource: ImageResource
  private var request: AnyObject?
  private var isLoading = false
  
  init(collectionViewLayout layout: UICollectionViewLayout, imagesResource: ImageResource) {
    self.imagesResource = imagesResource
    super.init(collectionViewLayout: layout)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle events
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Looker results"
    navigationController?.navigationBar.tintColor = AppColors.primary
    (self.collectionViewLayout as? MosaicLayout)?.delegate = self
    settingUpcollectionView()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    URLCache.shared.removeAllCachedResponses()
  }
  
  // MARK: - Collection view data source
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
      as? FeedCeel else {
        fatalError("Can not cast cell to FeeedCeel")
    }
    cell.feedItem = items[indexPath.row]
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.row == items.count-1 && !isLoading {
      loadNexImages()
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: self.view.frame.width, height: 32)
  }
  override func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionFooter {
      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionElementKindSectionFooter,
        withReuseIdentifier: self.footerReuseIdentifier,
        for: indexPath) as? FeedFooterView
      return header ?? UICollectionReusableView()
    } else {
      return UICollectionReusableView()
    }
  }
  // MARK: - Private methods
  private func settingUpcollectionView() {
    collectionView?.alwaysBounceVertical = true
    collectionView?.backgroundColor =  AppColors.secondaryLight
    collectionView?.register(FeedCeel.self, forCellWithReuseIdentifier: cellId)
    collectionView?.register(FeedFooterView.self,
                             forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                             withReuseIdentifier: self.footerReuseIdentifier)
  }
  
  private func loadNexImages() {
    isLoading = true
    imagesResource.page+=1
    let imagesRequest = ApiRequest(resource: imagesResource)
    request = imagesRequest
    
    imagesRequest.load { [weak self] imageItems in
      guard let items = imageItems else {
        self?.isLoading = false
        return
      }
      self?.items.append(contentsOf: items)
      self?.isLoading = false
    }
  }
}
extension FeedController: MosaicLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    return 200//items[indexPath.item].image.size.height
  }
}
// MARK: - Flow layout delegate
//extension FeedController: UICollectionViewDelegateFlowLayout {
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let picDimension = self.view.frame.size.width / 3.0
//    return CGSize(width: picDimension, height: picDimension)
//  }
//}

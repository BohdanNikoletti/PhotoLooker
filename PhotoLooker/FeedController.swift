//
//  ViewController.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 29.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties
    var items = [ImageItem]()
    private var cellId = "feedCell"
    
    //MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Looker results"
        self.navigationController?.navigationBar.tintColor = AppColors.primary
        
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
            as? FeedCeel else{
            fatalError("Can not cast cell to FeeedCeel")
        }
        cell.feedItem = items[indexPath.row]
        return cell
    }
    
    //MARK: - Flow layout delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 3.0
        return CGSize(width: picDimension, height: picDimension)
    }
    
    //MARK: - Private methods
    private func settingUpcollectionView(){
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor =  AppColors.secondaryLight
        collectionView?.register(FeedCeel.self, forCellWithReuseIdentifier: cellId)
    }
}



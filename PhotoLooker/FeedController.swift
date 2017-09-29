//
//  ViewController.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 29.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

class FeedController: UICollectionViewController {
    
    //MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Looker results"
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
}

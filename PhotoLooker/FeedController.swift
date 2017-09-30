//
//  ViewController.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 29.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Looker results"

        self.navigationController?.navigationBar.tintColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeeedCeel.self, forCellWithReuseIdentifier: "cell")
    }
    // MARK: - Collection view data source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    //MARK: - Flow layout delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let devider = arc4random_uniform(3) + 5
        let height = arc4random_uniform(50) + 100
        return CGSize(width: view.frame.width/CGFloat(devider), height: CGFloat(height))
    }
}

class FeeedCeel: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test title"
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews(){
        backgroundColor = UIColor.white
        backgroundView = UIImageView(image: UIImage(named: "empty"))
        backgroundView?.layer.borderWidth = 3
        backgroundView?.layer.borderColor = UIColor.white.cgColor
        addSubview(titleLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
    }
    
}

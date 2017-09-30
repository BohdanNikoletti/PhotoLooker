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
        return items.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FeeedCeel else{
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
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let leftRightInset = self.view.frame.size.width / 18.0
//        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
//    }
}

class FeeedCeel: UICollectionViewCell {
    
    fileprivate var request: AnyObject?
    var feedItem: ImageItem? {
        didSet{
            fetchImage()
            //titleLabel.text = feedItem?.title
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews(){
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
    }
    
    //MARK: - Private methods
    func fetchImage() {
        let imageUrl = feedItem?.imageURL
        let imageReq = ImageRequest(url: imageUrl!)
        request = imageReq
        imageReq.load(withCompletion: { [weak self] (image: UIImage?) in
            guard let image = image else {return}
            let imageView = UIImageView(image: image)
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.contentMode = .scaleAspectFit
            self?.backgroundView = imageView
        })
    }
}

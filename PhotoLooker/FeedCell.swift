//
//  FeedCell.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 01.10.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

let imageCache = NSCache<NSString, UIImage>()

class FeedCeel: UICollectionViewCell {
    
    //MARK: - Properties
    private var request: AnyObject?
    private var activityIndicatorView: NVActivityIndicatorView!
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    var feedItem: ImageItem? {
        didSet{
            titleLabel.text = feedItem?.title
            fetchImage()
        }
    }
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Private methods
    private func fetchImage() {
        guard let imageUrl = feedItem?.imageURL else{return}
        
        activityIndicatorView.startAnimating()

        let imageReq = ImageRequest(url: imageUrl)
        request = imageReq
        
        imageReq.load(withCompletion: {
            [weak self] (image: UIImage?) in
            guard let image = image else {return}
            //imageCache.setObject(image, forKey: NSString(string: imageUrl.path))
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            self?.backgroundView = imageView
            self?.titleLabel.text = ""
            self?.activityIndicatorView.stopAnimating()
        })
    }
//    private func getCached(image: String) -> UIImage{
//        if let image = imageCache.object(forKey: image){
//            
//        }
//    }
    private func setupViews(){
        
        backgroundColor = UIColor.white
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        let witdh = frame.width / 4
        let height = frame.height / 4
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 3, y: 3, width: witdh, height: height),
                                                        type: NVActivityIndicatorType.orbit)
        activityIndicatorView.color = UIColor.purple
    }
    
    private func addViews(){
        
        addSubview(titleLabel)
        addSubview(activityIndicatorView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-3-[v0]-3-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
    }
}

//
//  FeedCell.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 01.10.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class FeedCeel: UICollectionViewCell {
  
  // MARK: - Properties
  private var request: AnyObject?
  private let activityIndicatorView: NVActivityIndicatorView
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
  
  // MARK: - Properties observers
  var feedItem: ImageItem? {
    didSet {
      guard let itemToSet = feedItem else {
        return
      }
      titleLabel.text = itemToSet.title
      fetchImage(for: itemToSet.imageURL)
    }
  }
  
  // MARK: - Initializers
  override init(frame: CGRect) {
    let witdh = frame.width / 4
    let height = frame.height / 4
    activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 3, y: 3, width: witdh, height: height),
                                                    type: NVActivityIndicatorType.orbit)
    activityIndicatorView.color = AppColors.primaryDark
    super.init(frame: frame)
    setupViews()
    addViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("aDecoder initializer does not implemented")
  }
  
  // MARK: - Lifecycle events
  override func prepareForReuse() {
    super.prepareForReuse()
    self.backgroundView = nil
  }
  
  // MARK: - Private methods
  private func fetchImage(for imageUrl: URL?) {
    guard let imageUrl = imageUrl else { return }
    activityIndicatorView.startAnimating()
    let key = ImageCachingService.Key.id(key: imageUrl.absoluteString)

    let imageReq = ImageRequest(url: imageUrl)
    request = imageReq
    if let image = ImageCachingService
      .shared
      .getCachedImage(by: key) {
      self.setImageView(from: image)
    } else {
      imageReq.load(withCompletion: { [weak self] image in
        guard let image = image else { return }
        if imageUrl != self?.feedItem?.imageURL { return }
        ImageCachingService.shared.cache(image: image, key: key)
        self?.setImageView(from: image)
      })
    }
  }
  
  private func setupViews() {
    
    backgroundColor = AppColors.primary
    layer.borderWidth = 1
    layer.borderColor = UIColor.black.cgColor
  }
  
  private func addViews() {
    
    addSubview(titleLabel)
    addSubview(activityIndicatorView)
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[v0]-4-|", options: NSLayoutFormatOptions(),
                                                  metrics: nil, views: ["v0": titleLabel]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(),
                                                  metrics: nil, views: ["v0": titleLabel]))
  }
  
  private func setImageView(from image: UIImage) {
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    self.backgroundView = imageView
    self.titleLabel.text = ""
    self.activityIndicatorView.stopAnimating()
  }
}

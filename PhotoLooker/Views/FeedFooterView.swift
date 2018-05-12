//
//  CollectionFooterView.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 12.05.2018.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

import UIKit

final class FeedFooterView: UICollectionReusableView {

  // MARK: - UICollectionReusableView initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    addViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    addViews()
  }
  
  // MARK: - BaseCollectionReusableView methods
  func addViews() {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.color = AppColors.primaryDark
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
    activityIndicator.startAnimating()
  }
}

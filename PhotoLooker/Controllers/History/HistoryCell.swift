//
//  HistoryCell.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 01.10.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

final class HistoryCell: UITableViewCell {
    
    //MARK: - Properties
    private let searchPhraseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    private let historyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = AppColors.primaryDark.cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var historyItem: HistoryItem? {
        didSet{
            searchPhraseLabel.text = historyItem?.requestPhrase.uppercased()
            if let imageLocalURL = historyItem?.imagePath{
                historyImageView.image = getImage(from: imageLocalURL)
            }
        }
    }
    
    //MARK: - Lifecycle events
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    //MARK: - Private methods
    private func setupViews(){
        
        self.accessoryType = .disclosureIndicator
        separatorInset = UIEdgeInsets.zero
        let selectionBg = UIView()
        selectionBg.backgroundColor = AppColors.secondaryDark
        self.selectedBackgroundView = selectionBg
        backgroundColor = AppColors.primary
    
        addSubview(searchPhraseLabel)
        addSubview(historyImageView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(64)]-8-[v1]|", options: NSLayoutFormatOptions(),
                                                      metrics: nil, views: ["v0": historyImageView, "v1": searchPhraseLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(),
                                                      metrics: nil, views: ["v0": searchPhraseLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(),
                                                      metrics: nil, views: ["v0": historyImageView]))
        
    }
    private func getImage(from urlString: String) -> UIImage {
        guard let cashedImage = UIImage(contentsOfFile: urlString) else{
            return UIImage(named: "empty")!
        }
        return cashedImage
    }
}


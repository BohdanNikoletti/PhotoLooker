//
//  ImageItem.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 30.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

struct ImageItem{
    
    // MARK: - Properties
    let id: String
    let title: String
    let imageURL: URL
    
    // MARK: - Initializers
    init(id: String, title: String, imageURL: URL){
        self.id = id
        self.title = title
        self.imageURL = imageURL
    }
  
    init?(withJsonObject json: [String: Any]){
        guard let id = json["id"] as? String,
            let title = json["title"] as? String,
            let displaySizes = json["display_sizes"] as? [[String: Any]],
            let uri = displaySizes[0]["uri"] as? String
        else {
            return nil
        }
        self.id = id
        self.title = title
        self.imageURL = URL(string: uri)!
    }
}

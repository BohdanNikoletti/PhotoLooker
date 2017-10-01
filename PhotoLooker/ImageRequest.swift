//
//  ImageRequest.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 30.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

class ImageRequest {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}
extension ImageRequest: NetworkRequest {
    
    func decode(_ data: Data) -> UIImage?{
        return UIImage(data: data)
    }
    
    func load(withCompletion completion: @escaping(UIImage?) -> ()) {
        load(url, withCompletion: completion)
    }
}

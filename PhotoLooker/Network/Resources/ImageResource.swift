//
//  ImageRespurce.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 05.05.2018.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

import Foundation

struct ImageResource: ApiResource {
  
  var searchPhrase: String
  let methodPath = "/images"
  
  init(searchTo phrase: String){
    self.searchPhrase = phrase
  }
  
  func makeModel(serialization:  [String: Any]) -> ImageItem? {
    return ImageItem(withJsonObject: serialization)
  }
}

//
//  ImageRespurce.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 05.05.2018.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

import Foundation

struct ImageResource: ApiResource {
  struct Wrapper: Decodable {
    let images: [ImageItem]
  }
  var searchPhrase: String
  let methodPath = "/images"
  var page = 1

  init(searchTo phrase: String) {
    self.searchPhrase = phrase
  }

  func makeModel(data: Data) -> [ImageItem]? {
    do {
      return try decoder.decode(Wrapper.self, from: data).images
    } catch {
      print(error)
      return nil
    }
  }
}

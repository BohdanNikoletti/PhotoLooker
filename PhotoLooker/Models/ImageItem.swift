//
//  ImageItem.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 30.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

struct ImageItem: Decodable {
  
  // MARK: - Properties
  let id: String
  let title: String
  var imageURL: URL? {
    return URL(string: displaySize.uri)
  }
  var imageKey: String {
    return "\(id).jpg"
  }
  private var displaySize: DisplaySize
  
  enum CodingKeys: String, CodingKey {
    case id, title, displaySizes = "display_sizes"
  }
  
  // MARK: - Initializers
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let displaySizes = try container.decode([DisplaySize].self, forKey: .displaySizes)
    let id = try container.decode(String.self, forKey: .id)
    let title = try container.decode(String.self, forKey: .title)
    guard let displaySize = displaySizes.first else {
      let errorContext = DecodingError.Context(codingPath: [CodingKeys.displaySizes],
                                               debugDescription: "Display  sizes is corruptedß")
      throw DecodingError.dataCorrupted(errorContext)
    }
    self.init(id: id, title: title, displaySize: displaySize)
  }
  
  init (id: String, title: String, displaySize: DisplaySize) {
    self.id = id
    self.title = title
    self.displaySize = displaySize
  }
  
}

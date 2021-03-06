//
//  SearchStoryItem.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 30.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import Foundation
import RealmSwift

enum HistoryItemOperations {
  case add
  case delete
}

final class HistoryItem: Object {
  
  // MARK: - Properties
  @objc dynamic var imagePath: String = ""
  @objc dynamic var requestPhrase: String = ""
  var image: UIImage? {
    let key = ImageCachingService.Key.string(imagePath)
    return ImageCachingService.shared.getImage(by: key)
  }
  
  // MARK: - Public methods
  override static func primaryKey() -> String? {
    return "requestPhrase"
  }
  
  static func getHistory() -> [HistoryItem] {
    let realm = try? Realm()
    guard let historyItems = realm?.objects(HistoryItem.self) else {
      return []
    }
    return Array(historyItems)
  }
  
  static func perform(operation: HistoryItemOperations, on item: HistoryItem) {
    do {
      let realm = try Realm()
      try realm.write {
        
        switch operation {
        case .add:
          realm.add(item, update: true)
        case . delete:
          if item.isInvalidated {
            print("Item: \(item) is invalidated")
            return
          }
          let key = ImageCachingService.Key.string(item.imagePath)
          try? ImageCachingService.shared.delete(key)
          realm.delete(item)
        }
      }
    } catch {
      print("Can not \(operation) history item: \(item)")
    }
  }
}

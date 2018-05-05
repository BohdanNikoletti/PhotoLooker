//
//  SearchStoryItem.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 30.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import Foundation
import RealmSwift

enum HistoryItemOperations{
  case add
  case delete
}

final class HistoryItem: Object{
  
  //MARK: - Properties
  @objc dynamic var imagePath: String = ""
  @objc dynamic var requestPhrase: String = ""
  
  //MARK: - Public methods
  override static func primaryKey() ->String? {
    return "requestPhrase"
  }
  
  static func getHistory() -> [HistoryItem]{
    let realm = try! Realm()
    return Array(realm.objects(HistoryItem.self))
  }
  
  static func perform(operation: HistoryItemOperations, on item: HistoryItem){
    let realm = try! Realm()
    do {
      try realm.write {
        
        switch operation {
        case .add:
          realm.add(item, update: true)
        case . delete:
          if item.isInvalidated {
            print("Item: \(item) is invalidated")
            return
          }
          do{
            try FileManager.default.removeItem(at: URL(string: "file://\(item.imagePath)")!)
          }catch{
            print("error: \(error.localizedDescription)")
          }
          realm.delete(item)
        }
      }
    } catch {
      print("Can not \(operation) history item: \(item)")
    }
    
  }
}

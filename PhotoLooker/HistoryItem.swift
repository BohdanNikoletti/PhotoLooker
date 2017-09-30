//
//  SearchStoryItem.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 30.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryItem: Object{
    
    @objc dynamic var id = 0
    @objc dynamic var imagePath: String = ""
    @objc dynamic var requestPhrase: String = ""
    
    override static func primaryKey() ->String? {
        return "id"
    }
    
    static func getHistory() -> [HistoryItem]{
        let realm = try! Realm()
        return Array(realm.objects(HistoryItem.self))
    }
    
    static func add(historyItem item: HistoryItem){
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(item)
            }
        }catch {
            print("Can not save history item: \(item)")
        }
    }
}

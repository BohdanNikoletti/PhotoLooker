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
    //MARK: - Properties
    @objc dynamic var imagePath: String = ""
    @objc dynamic var requestPhrase: String = ""
    
    //MARK: - Static methods
    override static func primaryKey() ->String? {
        return "requestPhrase"
    }
    
    static func getHistory() -> [HistoryItem]{
        let realm = try! Realm()
        return Array(realm.objects(HistoryItem.self))
    }
    
    static func add(historyItem item: HistoryItem){
        let realm = try! Realm()
        do {
            try realm.write {
                print(item.requestPhrase)
                realm.add(item, update: true)
            }
        }catch {
            print("Can not save history item: \(item)")
        }
    }
    
    //MARK: - Public functions
    private static func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(HistoryItem.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

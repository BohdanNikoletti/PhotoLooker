//
//  Helpers.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 01.10.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import Foundation

extension FileManager {
    class func getDocumentDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths.first!
    }
}

//
//  Constants.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 01.10.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

enum AppColors {
    static let primaryDark = UIColor.purple
    static let primary = UIColor.white
    static let secondaryLight = UIColor(red: 0.953, green: 0.898, blue: 0.961, alpha: 1)
    static let secondaryDark = UIColor(red: 0.808, green: 0.576, blue: 0.847, alpha: 1)
}

struct APIEndpoints {
  
  private init() { }
  
  static let host = "api.gettyimages.com"
  static let apiKey = "3uzbn7xfgxc7gegnpetpp7k9"
}

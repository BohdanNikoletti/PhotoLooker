//
//  ImageCachingService.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 05.05.2018.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

import UIKit

final class ImageCachingService {
  
  // MARK: - Properties
  static let sharedInstance = ImageCachingService()
  private let fileManager = FileManager.default
  
  // MARK: - Initalizers
  private init() { }
  
  // MARK: - Public methods
  func saveImage(image: UIImage, key: String) {
    if let data = UIImagePNGRepresentation(image) {
      let filename = getDocumentsDirectory().appendingPathComponent("\(key).png")
      try? data.write(to: filename)
    }
  }
  
  func getImage(key: String) -> UIImage? {
    let filename = getDocumentsDirectory().appendingPathComponent("\(key).png")
    if fileManager.fileExists(atPath: filename.path),
      let imageData = fileManager.contents(atPath: filename.path) {
      return UIImage(data: imageData)
    }
    return nil
  }
  
  func delete( _ key: String) throws {
    let filename = getDocumentsDirectory().appendingPathComponent("\(key).png")
    if fileManager.fileExists(atPath: filename.path) {
      try fileManager.removeItem(atPath: filename.path)
    }
  }
  
  func refresh() {
    let path = getDocumentsDirectory().path
    guard let items = try? fileManager.contentsOfDirectory(atPath: path) else { return }
    
    for item in items {
      if !item.contains(".png") { continue }
      let completePath = path.appending("/").appending(item)
      try? fileManager.removeItem(atPath: completePath)
    }
  }
  
  // MARK: - Private methods
  private func getDocumentsDirectory() -> URL {
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
}

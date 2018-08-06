//
//  ImageCachingService.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 05.05.2018.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

import UIKit

private extension FileManager {
  var documentsDirectory: URL {
    let paths = self.urls(for: .documentDirectory,
                          in: .userDomainMask)
    return paths[0]
  }
}

final class ImageCachingService {
  
  // MARK: - Properties
  static let shared = ImageCachingService()
  private let cache = NSCache<NSString, UIImage>()
  private let fileManager = FileManager.default
  
  enum Key {
    case string(String)
    
    var identificator: String {
      switch self {
      case .string(let stringKey):
        return stringKey
      }
    }
    
    var file: URL {
      switch self {
      case .string(let stringKey):
        return FileManager.default
          .documentsDirectory
          .appendingPathComponent("\(stringKey).png")
      }
    }
  }
  // MARK: - Initalizers
  private init() {
    settingUpCache()
  }
  
  // MARK: - Public methods
  func cache(image: UIImage, key: Key) {
    cache.setObject(image, forKey: NSString(string: key.identificator))
  }
  func getCachedImage(by key: Key) -> UIImage? {
    return cache.object(forKey: NSString(string: key.identificator))
  }
  func save(image: UIImage, key: Key) {
    if let data = UIImagePNGRepresentation(image) {
      try? data.write(to: key.file)
    }
  }
  
  func getImage(by key: Key) -> UIImage? {
    let fileName = key.file
    if fileManager.fileExists(atPath: fileName.path),
      let imageData = fileManager.contents(atPath: fileName.path) {
      return UIImage(data: imageData)
    }
    return nil
  }
  
  func delete( _ key: Key) throws {
    let filename = key.file
    if fileManager.fileExists(atPath: filename.path) {
      try fileManager.removeItem(atPath: filename.path)
    }
  }
  
  func refresh() {
    let path =  FileManager.default.documentsDirectory.path
    guard let items = try? fileManager.contentsOfDirectory(atPath: path) else { return }
    
    for item in items {
      if !item.contains(".png") { continue }
      let completePath = path.appending("/").appending(item)
      try? fileManager.removeItem(atPath: completePath)
    }
  }
  
  // MARK: - Private methods
  private func settingUpCache() {
    let memoryCapacity = 30 * 512 * 512
    let diskCapacity = memoryCapacity
    let urlCache = URLCache(memoryCapacity: memoryCapacity,
                            diskCapacity: diskCapacity,
                            diskPath: "PhotoLooker")
    URLCache.shared = urlCache
  }
  
}

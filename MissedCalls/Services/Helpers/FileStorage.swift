//
//  FileStorage.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation
enum FileStorageError: Error {
  case badUrl
  case savingError
}

extension FileStorageError: LocalizedError {
  public var errorDescription: String? {
    switch self {
      case .badUrl:
        return "File storage error. Bad url"
      case .savingError:
        return "File storage error."
    }
  }
}

protocol FileStorageProtocol {
  func saveToFile(data: ViewData.CallsData) throws
  func loadFromFile() throws -> ViewData.CallsData?
}

class FileStorage {

}

// MARK: - FileStorageProtocol

extension FileStorage: FileStorageProtocol {
  func saveToFile(data: ViewData.CallsData) throws {
    guard let path = ViewData.archiveURL else { throw FileStorageError.badUrl }
    
    let encodeData = try? PropertyListEncoder().encode(data)
    try encodeData?.write(to: path)
  }

  func loadFromFile() throws -> ViewData.CallsData? {
    guard let url = ViewData.archiveURL else { throw FileStorageError.badUrl }

    if FileManager.default.fileExists(atPath: url.path) {
      let data = try Data(contentsOf: url)
      return try PropertyListDecoder().decode(ViewData.CallsData.self, from: data) 
    }

    return nil
  }
}

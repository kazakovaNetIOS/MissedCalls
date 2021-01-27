//
//  ParseHelper.swift
//  TestMVVM
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import Foundation

enum ParseError: Error {
  case invalidJson
}

extension ParseError: LocalizedError {
  public var errorDescription: String? {
    switch self {
      case .invalidJson:
        return "Parsing error. Invalid JSON"
    }
  }
}

protocol ParseHelperProtocol {
  func parseDataList<T: Decodable>(from data: Data) -> Result<T, ParseError>
}

final class MissedCallsParser {

}

// MARK: - ParseHelperProtocol

extension MissedCallsParser: ParseHelperProtocol {
  func parseDataList<T: Decodable>(from data: Data) -> Result<T, ParseError> {
    do {
      guard (try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]) != nil else {
        return .failure(.invalidJson)
      }

      let model = try JSONDecoder().decode(T.self, from: data)
      return .success(model)
    } catch {
      return .failure(.invalidJson)
    }
  }
}

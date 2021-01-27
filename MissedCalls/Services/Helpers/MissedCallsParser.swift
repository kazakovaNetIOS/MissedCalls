//
//  ParseHelper.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import Foundation

enum ParseError: Error {
  case invalidJson
  case emptyData
}

extension ParseError: LocalizedError {
  public var errorDescription: String? {
    switch self {
      case .invalidJson:
        return "Parsing error. Invalid JSON"
      case .emptyData:
        return "Parsing error. Empty data"
    }
  }
}

final class MissedCallsParser {
  typealias Model = MissedCallsViewData.CallsData

  func parseDataList(from data: Data) -> Result<Model, ParseError> {
    do {
      guard (try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]) != nil else {
        return .failure(.invalidJson)
      }

      let model = try JSONDecoder().decode(Model.self, from: data)
      return .success(model)
    } catch {
      return .failure(.invalidJson)
    }
  }
}

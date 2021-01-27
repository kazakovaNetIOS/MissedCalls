//
//  NetworkService.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import Foundation

enum NetworkError: Error {
  case badUrl
  case dataNotLoaded
}

extension NetworkError: LocalizedError {
  public var errorDescription: String? {
    switch self {
      case .badUrl:
        return "Network error. Bad url"
      case .dataNotLoaded:
        return "Network error. Data not loaded. Please try again later"
    }
  }
}

protocol NetworkServiceProtocol {
  func sendNetworkRequest(for url: String, process: @escaping (Result<Data, NetworkError>) -> Void)
}

final class NetworkService {

}

// MARK: - NetworkServiceProtocol

extension NetworkService: NetworkServiceProtocol {
  func sendNetworkRequest(for url: String, process: @escaping (Result<Data, NetworkError>) -> Void) {
    guard let url = URL(string: url) else {
      process(.failure(.badUrl))
      return
    }

    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data, (response as? HTTPURLResponse)?.statusCode == 200, error == nil else {
        process(.failure(.dataNotLoaded))
        return
      }
      process(.success(data))
    }.resume()
  }
}

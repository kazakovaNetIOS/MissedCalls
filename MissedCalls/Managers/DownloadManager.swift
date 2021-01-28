//
//  DownloadManager.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 28.01.2021.
//

import Foundation

protocol DownloadManagerProtocol {
  var loadData: ((Result<ViewData.CallsData, Error>?) -> ())? { get set }

  func startFetch()
}

class DownloadManager {
  public var loadData: ((Result<ViewData.CallsData, Error>?) -> ())?

  private var networkService: NetworkServiceProtocol
  private var parser: MissedCallsParser
  private var fileStorage: FileStorageProtocol

  init(networkService: NetworkServiceProtocol, parser: MissedCallsParser, fileStrorage: FileStorageProtocol) {
    self.networkService = networkService
    self.parser = parser
    self.fileStorage = fileStrorage
  }
}

// MARK: - DownloadManagerProtocol

extension DownloadManager: DownloadManagerProtocol {
  func startFetch() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      if let data = try? self?.fileStorage.loadFromFile() {
        self?.processParseResult(result: .success(data))
      }

      self?.networkService.sendNetworkRequest(for: Constants.url) { [weak self] (result) in
        switch result {
          case .success(let data):
            let parseResult = self?.parser.parseDataList(from: data)
            self?.processParseResult(result: parseResult)
          case .failure(let error):
            self?.loadData?(.failure(error))
        }
      }
    }
  }
}

// MARK: - Private

private extension DownloadManager {
  func processParseResult(result: Result<ViewData.CallsData, ParseError>?) {
    switch result {
      case .success(let loadedData):
        do {
          try fileStorage.saveToFile(data: loadedData)
        } catch {
          loadData?(.failure(FileStorageError.savingError))
        }
        loadData?(.success(loadedData))
      case .failure(let error):
        loadData?(.failure(error))
      case .none:
        loadData?(.failure(ParseError.emptyData))
    }
  }
}

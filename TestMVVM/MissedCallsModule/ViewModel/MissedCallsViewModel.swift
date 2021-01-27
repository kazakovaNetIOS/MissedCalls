//
//  MissedCallsViewModel.swift
//  TestMVVM
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import Foundation

enum Constants {
  static let url = "https://5e3c202ef2cb300014391b5a.mockapi.io/testapi"
}

protocol MissedCallsViewModelProtocol {
  var updateViewData: ((MissedCallsViewData) -> ())? { get set }

  func numberOfItemsInSection(section: Int) -> Int
  func viewDataForIndexPath(indexPath: IndexPath) -> Request?
  func startFetch()
}

final class MissedCallsViewModel {
  public var updateViewData: ((MissedCallsViewData) -> ())?
  private var networkService: NetworkServiceProtocol
  private var parser: MissedCallsParser
  private var viewData: MissedCallsViewData.CallsData?

  init() {
    networkService = NetworkService()
    parser = MissedCallsParser()
    updateViewData?(.initial)
  }
}

// MARK: - MissedCallsViewModelProtocol

extension MissedCallsViewModel: MissedCallsViewModelProtocol {
  func viewDataForIndexPath(indexPath: IndexPath) -> Request? {
    return viewData?.requests?[indexPath.row]
  }

  public func numberOfItemsInSection(section: Int) -> Int {
    return viewData?.requests?.count ?? 0
  }

  public func startFetch() {
    updateViewData?(.loading)

    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.networkService.sendNetworkRequest(for: Constants.url) { [weak self] (result) in
        switch result {
          case .success(let data):
            let parseResult = self?.parser.parseDataList(from: data)
            self?.processParseResult(result: parseResult)
          case .failure(let error):
            self?.populateOnMainQueue { [weak self] in
              self?.updateViewData?(.failure(error))
            }
        }
      }
    }
  }
}

// MARK: - Private

private extension MissedCallsViewModel {
  func processParseResult(result: Result<MissedCallsParser.Model, ParseError>?) {
    switch result {
      case .success(let loadedData):
        viewData = loadedData
        populateOnMainQueue { [weak self] in
          self?.updateViewData?(.success(loadedData))
        }
      case .failure(let error):
        populateOnMainQueue {  [weak self] in
          self?.updateViewData?(.failure(error))
        }
      case .none:
        populateOnMainQueue {  [weak self] in
          self?.updateViewData?(.failure(ParseError.emptyData))
        }
    }
  }

  func populateOnMainQueue(update: @escaping () -> Void) {
    DispatchQueue.main.async {
      update()
    }
  }
}

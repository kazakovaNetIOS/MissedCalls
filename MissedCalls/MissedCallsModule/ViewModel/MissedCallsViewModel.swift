//
//  MissedCallsViewModel.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import Foundation

protocol MissedCallsViewModelProtocol {
  var updateViewData: ((ViewData) -> ())? { get set }

  func numberOfItemsInSection(section: Int) -> Int
  func viewDataForIndexPath(indexPath: IndexPath) -> Request?
  func start()
}

final class MissedCallsViewModel {
  public var updateViewData: ((ViewData) -> ())?
  private var downloadManager: DownloadManagerProtocol
  private var viewData: ViewData.CallsData?

  init(downloadManager: DownloadManagerProtocol) {
    self.downloadManager = downloadManager
    self.downloadManager.loadData = { [weak self] result in
      self?.processParseResult(result: result)
    }
    updateViewData?(.loading)
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

  public func start() {
    updateViewData?(.loading)

    downloadManager.startFetch()
  }
}

// MARK: - Private

private extension MissedCallsViewModel {
  func processParseResult(result: Result<ViewData.CallsData, Error>?) {
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

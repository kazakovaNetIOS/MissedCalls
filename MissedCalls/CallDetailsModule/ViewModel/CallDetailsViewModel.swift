//
//  CallDetailsViewModel.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 28.01.2021.
//

import Foundation

protocol CallDetailsViewModelProtocol {
  var updateViewData: ((Request) -> ())? { get set }

  func start()
}

final class CallDetailsViewModel {
  public var updateViewData: ((Request) -> ())?
  private var viewData: Request

  init(viewData: Request) {
    self.viewData = viewData
  }
}

// MARK: - CallDetailsViewModelProtocol

extension CallDetailsViewModel: CallDetailsViewModelProtocol {
  func start() {
    updateViewData?(viewData)
  }
}

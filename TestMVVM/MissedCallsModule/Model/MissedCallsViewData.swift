//
//  MissedCallsViewData.swift
//  TestMVVM
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import Foundation

typealias Request = MissedCallsViewData.Request

enum MissedCallsViewData {
  case initial
  case loading
  case success(CallsData)
  case failure(Error)

  // MARK: - CallsData
  struct CallsData: Codable {
    let requests: [Request]?
  }

  // MARK: - Request
  struct Request: Codable {
    let id: String?
    let state: String?
    let client: Client?
    let type: String?
    let created: String?
    let businessNumber: BusinessNumber?
    let origin: String?
    let favorite: Bool?
    let duration: String?
  }

  // MARK: - BusinessNumber
  struct BusinessNumber: Codable {
    let number: String?
    let label: String?
  }

  // MARK: - Client
  struct Client: Codable {
    let address: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
      case address
      case name = "Name"
    }
  }
}

//
//  ViewData.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import Foundation

typealias Request = ViewData.Request

enum ViewData {
  case loading
  case success(CallsData)
  case failure(Error)

  static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
  static let archiveURL = documentsDirectory?.appendingPathComponent("missedCalls")

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
    private let _created: String?
    var created: String? {
      guard let created = _created else { return nil }

      return Date.date(from: created)?.toHoursMinutesString()
    }
    let businessNumber: BusinessNumber?
    let origin: String?
    let favorite: Bool?
    private let _duration: String?
    var duration: String? {
      guard let duration = _duration else { return nil }

      var durationArr = duration.components(separatedBy: ":")
      if durationArr[0] == "00" {
        durationArr.remove(at: 0)
      }

      return durationArr.joined(separator: ":")
    }

    enum CodingKeys: String, CodingKey {
      case id
      case state
      case client
      case type
      case _created = "created"
      case businessNumber
      case origin
      case favorite
      case _duration = "duration"
    }
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

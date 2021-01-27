//
//  Date+Extensions.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 17.01.2021.
//

import Foundation

extension Date {
  static func date(from stringDate: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
    return dateFormatter.date(from: stringDate)
  }

  func toHoursMinutesString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH':'mm aaa"
    return dateFormatter.string(from: self)
  }
}

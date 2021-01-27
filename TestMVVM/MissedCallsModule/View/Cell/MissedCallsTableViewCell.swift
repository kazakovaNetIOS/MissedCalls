//
//  MissedCallsTableViewCell.swift
//  TestMVVM
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import UIKit

class MissedCallsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var label: UILabel!
  
  func configure(with model: Request) {
    label.text = model.client?.name
  }
}

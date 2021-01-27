//
//  MissedCallsTableViewCell.swift
//  TestMVVM
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import UIKit

class MissedCallsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var bottomLayer: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!

  override func awakeFromNib() {
    setupViews()
  }
  
  func configure(with model: Request) {
    phoneLabel.text = model.client?.address

    if let clientName = model.client?.name {
      nameLabel.text = clientName
      phoneLabel.font = UIFont(name: "SF-Pro-Display-Regular", size: 17)
    } else {
      nameLabel.isHidden = true
      phoneLabel.font = UIFont(name: "SF-Pro-Display-Semibold", size: 17)
      phoneLabel.topAnchor.constraint(equalTo: topAnchor, constant: 23).isActive = true
    }

    durationLabel.text = model.duration
  }
}

// MARK: - Private

private extension MissedCallsTableViewCell {
  func setupViews() {
    bottomLayer.layer.cornerRadius = 8
    bottomLayer.layer.shadowColor = UIColor.black.cgColor
    bottomLayer.layer.shadowOpacity = 0.1
    bottomLayer.layer.shadowOffset = .zero
    bottomLayer.layer.shadowRadius = 8
  }
}

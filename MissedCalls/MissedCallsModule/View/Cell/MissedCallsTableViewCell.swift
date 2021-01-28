//
//  MissedCallsTableViewCell.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import UIKit

class MissedCallsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var bottomLayer: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var creationLabel: UILabel!
  @IBOutlet weak var phoneToName: NSLayoutConstraint!
  @IBOutlet weak var phoneToTop: NSLayoutConstraint!

  override func awakeFromNib() {
    setupViews()
  }
  
  func configure(with model: Request) {
    phoneLabel.text = model.client?.address

    if let clientName = model.client?.name {
      nameLabel.text = clientName
      phoneToName.isActive = true
      phoneToTop.isActive = false
      phoneLabel.font = UIFont(name: "SF-Pro-Display-Regular", size: 17)
    } else {
      nameLabel.removeFromSuperview()
      phoneToName.isActive = false
      phoneToTop.isActive = true
      phoneLabel.font = UIFont(name: "SF-Pro-Display-Semibold", size: 17)
    }

    durationLabel.text = model.duration
    creationLabel.text = model.created
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

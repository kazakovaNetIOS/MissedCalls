//
//  CallDetailsViewController.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 28.01.2021.
//

import UIKit

class CallDetailsViewController: UIViewController {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var businessNumberTitleLabel: UILabel!
  @IBOutlet weak var businessNumberLabel: UILabel!
  @IBOutlet weak var foldButton: UIView!
  @IBOutlet weak var wrappedView: UIView!
  
  var viewModel: CallDetailsViewModelProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()

    viewModel?.updateViewData = { [weak self] viewData in
      self?.updateView(with: viewData)
    }
    viewModel?.start()
  }
}

// MARK: - Private

private extension CallDetailsViewController {
  func setupViews() {
    navigationController?.title = "Missed call"
    foldButton.layer.cornerRadius = 2
    foldButton.clipsToBounds = true

    wrappedView.layer.cornerRadius = 16
    wrappedView.layer.shadowColor = UIColor.black.cgColor
    wrappedView.layer.shadowOpacity = 0.05
    wrappedView.layer.shadowOffset = .zero
    wrappedView.layer.shadowRadius = 16
  }

  func updateView(with model: Request) {
    nameLabel.text = model.client?.name
    phoneLabel.text = model.client?.address
    durationLabel.text = model.duration
    businessNumberTitleLabel.text = model.businessNumber?.label
    businessNumberLabel.text = model.businessNumber?.number
  }
}

// MARK: - Instantiation from storybord

extension CallDetailsViewController {
  static func storyboardInstance() -> UINavigationController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? UINavigationController
  }
}

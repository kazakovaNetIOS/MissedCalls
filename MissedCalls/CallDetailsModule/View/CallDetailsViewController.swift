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

  var viewModel: CallDetailsViewModelProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.title = "Missed call"
    viewModel?.updateViewData = { [weak self] viewData in
      self?.updateView(with: viewData)
    }
    viewModel?.start()
  }
}

// MARK: - Private

private extension CallDetailsViewController {
  func updateView(with model: Request) {
    nameLabel.text = model.client?.name
    phoneLabel.text = model.client?.address
    durationLabel.text = model.duration
  }
}

// MARK: - Instantiation from storybord

extension CallDetailsViewController {
  static func storyboardInstance() -> UINavigationController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? UINavigationController
  }
}

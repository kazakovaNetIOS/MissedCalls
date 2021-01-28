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
  @IBOutlet weak var businessNumberTextLabel: UILabel!
  @IBOutlet weak var businessNumberTitleLabel: UILabel!
  @IBOutlet weak var businessNumberLabel: UILabel!
  @IBOutlet weak var foldButton: UIView!
  @IBOutlet weak var wrappedView: UIView!
  @IBOutlet weak var wrappedViewHeightConstant: NSLayoutConstraint!
  @IBOutlet weak var iconImageView: UIImageView!
  
  private var wrappedViewMaxHeight: CGFloat = 0
  private var wrappedViewMinHeight: CGFloat = 0
  
  var viewModel: CallDetailsViewModelProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()

    viewModel?.updateViewData = { [weak self] viewData in
      self?.updateView(with: viewData)
    }
    viewModel?.start()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    wrappedViewMaxHeight = 16
    for subView in wrappedView.subviews {
      wrappedViewMaxHeight = wrappedViewMaxHeight + subView.bounds.size.height
    }

    wrappedViewMinHeight = 50
    wrappedViewMinHeight += durationLabel.frame.maxY > phoneLabel.frame.maxY ? durationLabel.frame.maxY : phoneLabel.frame.maxY

    wrappedView.frame = CGRect(origin: wrappedView.frame.origin, size: CGSize(width: wrappedView.frame.size.width, height: wrappedViewMaxHeight))
  }
}

// MARK: - Private

private extension CallDetailsViewController {
  func setupViews() {
    navigationController?.title = "Missed call"
    foldButton.layer.cornerRadius = 2
    foldButton.clipsToBounds = true

    nameLabel.tag = 1
    phoneLabel.tag = 1

    wrappedView.layer.cornerRadius = 16
    wrappedView.layer.shadowColor = UIColor.black.cgColor
    wrappedView.layer.shadowOpacity = 0.5
    wrappedView.layer.shadowOffset = .zero
    wrappedView.layer.shadowRadius = 16

    let swipeUpRecognizer = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(respondToSwipeGesture))
    swipeUpRecognizer.direction = .up
    let swipeDownRecognizer = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(respondToSwipeGesture))
    swipeDownRecognizer.direction = .down
    view.addGestureRecognizer(swipeUpRecognizer)
    view.addGestureRecognizer(swipeDownRecognizer)
  }

  func updateView(with model: Request) {
    nameLabel.text = model.client?.name
    phoneLabel.text = model.client?.address
    durationLabel.text = model.duration
    businessNumberTitleLabel.text = model.businessNumber?.label
    businessNumberLabel.text = model.businessNumber?.number
  }

  @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
        case .up:
          wrappedViewHeightConstant.constant = wrappedViewMinHeight

          UIView.animate(withDuration: 0.3) {
            self.businessNumberTextLabel.alpha = 0
            self.businessNumberTitleLabel.alpha = 0
            self.businessNumberLabel.alpha = 0
          }

          UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
          }
        case .down:
          wrappedViewHeightConstant.constant = wrappedViewMaxHeight

          UIView.animate(withDuration: 2.5) {
            self.businessNumberTextLabel.alpha = 1
            self.businessNumberTitleLabel.alpha = 1
            self.businessNumberLabel.alpha = 1
          }

          UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
          }
        default:
          break
      }
    }
  }
}

// MARK: - Instantiation from storybord

extension CallDetailsViewController {
  static func storyboardInstance() -> CallDetailsViewController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? CallDetailsViewController
  }
}

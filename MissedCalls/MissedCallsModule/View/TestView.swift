//
//  TestView.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import UIKit

class TestView: UIView {
  var viewData: ViewData = .loading {
    didSet {
      setNeedsLayout()
    }
  }
  lazy var imageView = makeImageView()
  lazy var activityIndicator = makeActivityIndicatorView()
  lazy var titleLabel = makeTitleLabel()
  lazy var descriptionLabel = makeDescriptionLabel()

  override func layoutSubviews() {
    super.layoutSubviews()

//    switch viewData {
//      case .initial:
//        update(viewData: nil, isHidden:  true)
//        activityIndicator.stopAnimating()
//      case .loading:
//        activityIndicator.startAnimating()
//      case .success(let success):
//        update(viewData: success, isHidden: false)
//        activityIndicator.stopAnimating()
//      case .failure(let failure):
//        // todo
////        update(viewData: failure, isHidden: false)
//        activityIndicator.stopAnimating()
//    }
  }
}

private extension TestView {
  func update(viewData: ViewData.CallsData?, isHidden: Bool) {
//    imageView.image = UIImage(named: viewData?.icon ?? "")
//    titleLabel.text = viewData?.title
//    descriptionLabel.text = viewData?.description
    imageView.isHidden = isHidden
    titleLabel.isHidden = isHidden
    descriptionLabel.isHidden = isHidden
  }
}

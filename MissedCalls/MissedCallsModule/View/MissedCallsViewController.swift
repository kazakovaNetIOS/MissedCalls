//
//  MissedCallsViewController.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import UIKit

class MissedCallsViewController: UIViewController {
  private let tableCellIdentifier = "MissedCallsTableViewCell"
  var viewModel: MissedCallsViewModelProtocol?

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    updateView()

    viewModel?.startFetch()
  }

  private func setupView() {
    tableView.register(UINib(nibName: tableCellIdentifier, bundle: nil),
                            forCellReuseIdentifier: tableCellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
  }

  private func updateView() {
    viewModel?.updateViewData = { [weak self] viewData in
      switch viewData {
        case .success(_):
          self?.activityIndicator.stopAnimating()
          self?.tableView.reloadData()
        case .failure(let error):
          self?.activityIndicator.stopAnimating()
          print(error.localizedDescription)
        case .loading:
          self?.activityIndicator.startAnimating()
      }

    }
  }
}

// MARK: - UITableViewDataSource

extension MissedCallsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.numberOfItemsInSection(section: section) ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as? MissedCallsTableViewCell,
          let viewData = viewModel?.viewDataForIndexPath(indexPath: indexPath) else {
      return UITableViewCell()
    }

    cell.configure(with: viewData)

    return cell
  }
}

// MARK: - UITableViewDelegate

extension MissedCallsViewController: UITableViewDelegate {

}

// MARK: - Instantiation from storybord

extension MissedCallsViewController {
  static func storyboardInstance() -> UINavigationController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? UINavigationController
  }
}

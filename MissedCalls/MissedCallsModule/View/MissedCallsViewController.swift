//
//  MissedCallsViewController.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import UIKit

class MissedCallsViewController: UIViewController {
  private let tableCellIdentifier = "MissedCallsTableViewCell"

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  var viewModel: MissedCallsViewModelProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()

    viewModel?.updateViewData = { [weak self] viewData in
      switch viewData {
        case .success(_):
          self?.activityIndicator.stopAnimating()
          self?.tableView.reloadData()
        case .failure(let error):
          self?.activityIndicator.stopAnimating()
          self?.showError(with: error.localizedDescription)
        case .loading:
          self?.activityIndicator.startAnimating()
      }
    }
    viewModel?.start()
  }
}

// MARK: - Private

private extension MissedCallsViewController {
  private func showError(with errorString: String) {
    let alertController = UIAlertController(title: "Ошибка",
                                            message: errorString,
                                            preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))

    present(alertController, animated: true)
  }

  func setupView() {
    tableView.register(UINib(nibName: tableCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: tableCellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
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
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewData = viewModel?.viewDataForIndexPath(indexPath: indexPath),
          let detailVC = CallDetailsViewController.storyboardInstance() else { return }
    detailVC.viewModel = CallDetailsViewModel(viewData: viewData)
    navigationController?.pushViewController(detailVC, animated: true)
  }
}

// MARK: - Instantiation from storybord

extension MissedCallsViewController {
  static func storyboardInstance() -> UINavigationController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? UINavigationController
  }
}

//
//  MissedCallsViewController.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import UIKit

class MissedCallsViewController: UIViewController {
  private let tableCellIdentifier = "MissedCallsTableViewCell"
  private var viewModel: MissedCallsViewModelProtocol?

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    // todo needs DI
    viewModel = MissedCallsViewModel()
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
      self?.tableView.reloadData()
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

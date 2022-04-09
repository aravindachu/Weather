//
//  HomeViewController.swift
//  Weather
//
//  Created by Aravind Vijayan on 01/03/22.
//

import UIKit

final class HomeViewController: UIViewController {
    var viewModel: HomeViewModel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var historyTableView: UITableView!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var tableviewHeightConstraint: NSLayoutConstraint!

    private let kCellIdentifier = "HistoryTableViewCell"


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        bindViewModel()
        historyTableView.register(cell: HistoryTableViewCell.self)
        historyTableView.estimatedRowHeight = 40
        historyTableView.rowHeight = UITableView.automaticDimension
        searchBar.delegate = self
    }

    private func hideTableView(shouldHide: Bool) {
        historyTableView.isHidden = shouldHide
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.tableviewHeightConstraint.constant = shouldHide ? 0 : 150
        }
    }

    private func bindViewModel() {
        self.viewModel.iconObservable.bindAndUpdate { [weak self] image in
            self?.iconImageView.image = image
        }

        self.viewModel.tempObservable.bindAndUpdate { [weak self] temp in
            guard temp.isEmpty == false else { return }
            self?.temperatureLabel.attributedText = temp.addSuperScript(superScript: "o")
        }

        self.viewModel.descObservable.bindAndUpdate { [weak self] desc in
            self?.descriptionLabel.text = desc
        }

        self.viewModel.placeObservable.bindAndUpdate { [weak self] place in
            self?.placeLabel.text = place
        }

        self.viewModel.historyDataSource.bindAndUpdate  { [weak self] dataSource in
            self?.hideTableView(shouldHide: dataSource.isEmpty)
            self?.historyTableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count is", self.viewModel.historyDataSource.value.count)

        return self.viewModel.historyDataSource.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeue(cell: HistoryTableViewCell.self, at: indexPath)
        guard let cellViewModel = viewModel.historyDataSource.value[safe: indexPath.row] else { return cell }
        cell.configure(using: cellViewModel)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = viewModel.itemSelected(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(using: searchText, showOld: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        viewModel.search(using: "")
        view.endEditing(true)

    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.search(using: "", showOld: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(using: searchBar.searchTextField.text ?? "")
    }
}

//
//  DetailsViewController.swift
//  Weather
//
//  Created by Aravind Vijayan on 03/03/22.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var tableview: UITableView!

    var viewModel: DetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        tableview.register(cell: DetailTableViewCell.self)
        tableview.estimatedRowHeight = 40
        tableview.rowHeight = UITableView.automaticDimension
        setupBinding()
    }

    private func setupBinding() {
        self.viewModel.iconObservable.bindAndUpdate { [weak self] image in
            self?.iconImageView.image = image
        }

        self.viewModel.tempObservable.bindAndUpdate { [weak self] temp in
            guard temp.isEmpty == false else { return }
            self?.tempLabel.attributedText = temp.addSuperScript(superScript: "o")
        }

        self.viewModel.descObservable.bindAndUpdate { [weak self] desc in
            self?.descLabel.text = desc
        }

        self.viewModel.placeObservable.bindAndUpdate { [weak self] place in
            self?.placeLabel.text = place
        }

        self.viewModel.dataSource.bindAndUpdate  { [weak self] dataSource in
            self?.tableview.reloadData()
        }
    }
    
}

extension DetailsViewController: UITableViewDelegate {

}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.dataSource.value[indexPath.row]
        let cell = tableView.dequeue(cell: DetailTableViewCell.self, at: indexPath)
        cell.configure(using: cellViewModel)
        return cell
    }

}

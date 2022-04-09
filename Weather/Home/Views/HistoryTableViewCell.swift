//
//  HistoryTableViewCell.swift
//  Weather
//
//  Created by Aravind Vijayan on 03/03/22.
//

import UIKit

class HistoryTableViewCell: UITableViewCell, NibRegister {

    @IBOutlet weak var titleLabel: UILabel!


    func configure(using viewModel: HistoryCellViewModel) {
        titleLabel.text = viewModel.title
    }

}

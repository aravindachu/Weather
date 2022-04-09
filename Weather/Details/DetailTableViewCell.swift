//
//  DetailTableViewCell.swift
//  Weather
//
//  Created by Aravind Vijayan on 03/03/22.
//

import UIKit

class DetailTableViewCell: UITableViewCell, NibRegister {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(using viewModel: DetailCellViewModel) {
        iconImageView.image = viewModel.image
        tempLabel.text = viewModel.temp
        descLabel.text = viewModel.desc
    }
    
}

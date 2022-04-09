//
//  DetailsBuilder.swift
//  Weather
//
//  Created by Aravind Vijayan on 03/03/22.
//

import Foundation

import UIKit

final class DetailsBuilder {
    static func build(location: Location) -> DetailsViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle(for: DetailsViewController.self))
        let viewController = DetailsViewController.instantiate(from: storyBoard)
        viewController.viewModel = DetailsViewModel(location: location)
        return viewController
    }
}

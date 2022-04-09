//
//  HomeBuilder.swift
//  Weather
//
//  Created by Aravind Vijayan on 01/03/22.
//

import UIKit

final class HomeBuilder {
    static func build() -> HomeViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle(for: HomeViewController.self))
        let viewController = HomeViewController.instantiate(from: storyBoard)
        viewController.viewModel = HomeViewModel()
        return viewController
    }
}

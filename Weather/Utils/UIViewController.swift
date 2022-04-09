//
//  UIViewController.swift
//  Weather
//
//  Created by Aravind Vijayan on 01/03/22.
//

import UIKit

extension UIViewController {
    class func instantiate<T: UIViewController>(from storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }

    class func instantiate(from storyboard: UIStoryboard) -> Self {
        return instantiate(from: storyboard, identifier: String(describing: self))
    }
}

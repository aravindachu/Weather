//
//  UITableView.swift
//  Weather
//
//  Created by Aravind Vijayan on 03/03/22.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cell ofType: T.Type) where T: NibRegister {
        self.register(UINib(nibName: ofType.nibName, bundle: Bundle(for: ofType.self)), forCellReuseIdentifier: ofType.identifier)
    }

    func dequeue<T: UITableViewCell>(cell ofType: T.Type, at indexPath: IndexPath) -> T where T: NibRegister {
        self.dequeueReusableCell(withIdentifier: ofType.identifier, for: indexPath) as! T
    }
}

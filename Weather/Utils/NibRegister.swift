//
//  NibRegister.swift
//  Weather
//
//  Created by Aravind Vijayan on 03/03/22.
//

import Foundation

protocol NibRegister {
    static var identifier: String { get }
    static var nibName: String { get }
}

extension NibRegister {
    static var identifier: String {
        String(describing: Self.self)
    }

    static var nibName: String {
        String(describing: Self.self)
    }
}

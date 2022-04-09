//
//  String.swift
//  Weather
//
//  Created by Aravind Vijayan on 03/03/22.
//

import Foundation
import UIKit

extension String {
    func addSuperScript(superScript: String, font: UIFont = UIFont.systemFont(ofSize: 22, weight: .bold), superFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .bold)) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self + superScript, attributes: [.font: font, .foregroundColor: UIColor.black])
        attributedString.setAttributes([.font: superFont, .baselineOffset: 9, .foregroundColor: UIColor.black], range: NSRange(location: self.count, length: superScript.count))
        return attributedString
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        self.indices.contains(index) ? self[index] : nil
    }
}

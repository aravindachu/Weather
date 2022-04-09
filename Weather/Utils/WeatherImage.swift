//
//  WeatherImage.swift
//  Weather
//
//  Created by Aravind Vijayan on 02/03/22.
//

import UIKit

class WeatherImage {
    static func image(named: String) -> UIImage {
        UIImage(named: named, in: Bundle(for: WeatherImage.self), compatibleWith: nil)!
    }

    static func getImage(for abbrevation: String) -> UIImage {
        return WeatherImage.image(named: abbrevation.lowercased())
    }
}

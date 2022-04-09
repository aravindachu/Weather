//
//  API.swift
//  Weather
//
//  Created by Aravind Vijayan on 01/03/22.
//

import Foundation

let kBaseURL = "https://www.metaweather.com/api"

enum API: String {
    case cordinatesSearch = "/location/search/?lattlong=%@,%@"
    case querySearch = "/location/search/?query=%@"
    case weather = "/api/location/%@"

    var withbaseURL: String {
        return kBaseURL + self.rawValue
    }
}

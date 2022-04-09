//
//  Weather.swift
//  Weather
//
//  Created by Aravind Vijayan on 02/03/22.
//

import Foundation

struct Weather: Codable {
    var state: String
    var stateAbbr: String
    var temp: Double

    enum CodingKeys: String, CodingKey {
        case state = "weather_state_name"
        case stateAbbr = "weather_state_abbr"
        case temp = "the_temp"
    }
}

struct ConsolidatedWeather: Codable {
    var weatherArray: [Weather]
    enum CodingKeys: String, CodingKey {
        case weatherArray = "consolidated_weather"
    }
}

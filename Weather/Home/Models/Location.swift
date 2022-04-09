//
//  Location.swift
//  Weather
//
//  Created by Aravind Vijayan on 02/03/22.
//

import Foundation
import UIKit

struct Location: Codable {
    var title: String
    var type: String
    var woeid: Int64

    enum CodingKeys: String, CodingKey {
        case title
        case type = "location_type"
        case woeid
    }

    init(dbModel: LocationModel) {
        self.title = dbModel.title ?? ""
        self.type = dbModel.type ?? ""
        self.woeid = dbModel.woeid
    }
}

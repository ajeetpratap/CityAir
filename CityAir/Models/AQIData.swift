//
//  AQIData.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 28/11/21.
//

import Foundation

struct AQIData: Codable {
    var aqi: Float {
        didSet {
            aqi = max(aqi,0)
        }
    }
    var city: String
    init(aqi: Float, city: String) {
        self.aqi = aqi
        self.city = city
    }
}

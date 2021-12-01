//
//  CityData.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 28/11/21.
//

import Foundation

protocol CityData {
    var name: String {get set}
    var record: [AQIDataModel] {get set}
}

class AQIDataModel {
    var aqiValue: Float = 0.0
    var date:Date = Date()
    init(value: Float, date: Date) {
        self.aqiValue = value
        self.date = date
    }
}

class CityDataObject: CityData {
    var name: String
    var record: [AQIDataModel] = []
    
    init(city: String) {
        self.name = city
    }
    
}

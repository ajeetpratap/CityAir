//
//  Extensions.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 29/11/21.
//

import Foundation

extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
    
    func getSeconds() -> Int {
        let calendar = Calendar.current
        return calendar.component(.second, from: self)
    }
}


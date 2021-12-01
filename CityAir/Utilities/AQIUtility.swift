//
//  AQIUtility.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 28/11/21.
//

import Foundation
import UIKit

enum AirQuality: String {
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor
    case severe
    
    var description : String {
        switch self {
        case .good: return "Good"
        case .satisfactory: return "Satisfactory"
        case .moderate: return "Moderate"
        case .poor : return "Poor"
        case .veryPoor: return "Very Poor"
        case .severe: return "Severe"
        }
      }
    
    func getAirQualityColor() -> UIColor {
        switch self {
        case .good:
            return #colorLiteral(red: 0.5215686275, green: 0.7019607843, blue: 0.4078431373, alpha: 1)
        case .satisfactory:
            return #colorLiteral(red: 0.6784313725, green: 0.7803921569, blue: 0.3607843137, alpha: 1)
        case .moderate:
            return #colorLiteral(red: 0.9921568627, green: 0.9725490196, blue: 0.2980392157, alpha: 1)
        case .poor:
            return #colorLiteral(red: 0.8666666667, green: 0.6078431373, blue: 0.2431372549, alpha: 1)
        case .veryPoor:
            return #colorLiteral(red: 0.7921568627, green: 0.2549019608, blue: 0.2156862745, alpha: 1)
        case .severe:
            return #colorLiteral(red: 0.5882352941, green: 0.1921568627, blue: 0.1607843137, alpha: 1)
        }
    }
}

class AQIUtility {
    static func getAirQuality(aqi: Float) -> AirQuality {
        switch aqi {
        case 0...50:
            return .good
        
        case 51...100:
            return .satisfactory
        
        case 101...200:
            return .moderate
        
        case 201...300:
            return .poor
        
        case 301...400:
            return .veryPoor
        
        default:
            return .severe
        }
    }
}

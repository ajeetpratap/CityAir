//
//  CityTableViewCell.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 28/11/21.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CityTableViewCell"

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var airQuality: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var aqiText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadCell(data: CityDataObject?) {
        guard let cityData = data else {return}
        cityName.text = cityData.name.capitalized
        if let aqi = cityData.record.last?.aqiValue {
            airQuality.text = AQIUtility.getAirQuality(aqi: aqi).description
            airQuality.textColor = AQIUtility.getAirQuality(aqi: aqi).getAirQualityColor()
            aqiText.text = String(format: "%.2f", aqi)
            aqiText.textColor = AQIUtility.getAirQuality(aqi: aqi).getAirQualityColor()
        }
        if let date = cityData.record.last?.date {
            if date.timeAgo() == "0 seconds" {
                timestamp.text = "Just now"
            } else {
                timestamp.text = date.timeAgo() + " ago"
            }
        }
        
    }

}

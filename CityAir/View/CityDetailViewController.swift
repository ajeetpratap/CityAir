//
//  CityDetailViewController.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 28/11/21.
//

import UIKit
import Highcharts

class CityDetailViewController: UIViewController {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var airQuality: UILabel!
    @IBOutlet weak var aqiText: UILabel!
    
    @IBOutlet weak var chartView: HIChartView!
    var name: String = ""
    var viewModel: CityListViewModel?
    var initialCityData: CityDataObject?
    var startDate: NSInteger!
    var AQIPoints = [Float]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialCityData()
        setupChart()
        setUpViewModel()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.unsubscribe()
    }
    
    func setUpViewModel() {
        guard let _viewModel = viewModel else {
            return
        }
        _viewModel.subscribeTo(city: name)
        _viewModel.publishCityData.bind { [weak self] cityData in
            guard let data = cityData, data.name == self?.name else {return}
            if let lastValue = data.record.last {
                self?.AQIPoints.append(lastValue.aqiValue)
                self?.setupCityInfo(cityData:data)
                self?.updateGraphView()
            }
        }
    }
    
    
    deinit {
        print("City Detail deinit")
    }
    
    
    func updateGraphView() {
        let updatedOptions = HIOptions()
        let series = HISeries()
        series.data = self.AQIPoints
        updatedOptions.series = [series]
        self.chartView.update(updatedOptions)
    }
    
    func setupCityInfo(cityData: CityDataObject) {
        cityName.text = cityData.name.capitalized
        if let aqi = cityData.record.last?.aqiValue {
            airQuality.text = AQIUtility.getAirQuality(aqi: aqi).description
            airQuality.textColor = AQIUtility.getAirQuality(aqi: aqi).getAirQualityColor()
            aqiText.text = String(format: "%.2f", aqi)
            aqiText.textColor = AQIUtility.getAirQuality(aqi: aqi).getAirQualityColor()
        }
    }
    
    func loadInitialCityData() {
        guard let cityData = initialCityData else {return}
        setupCityInfo(cityData: cityData)
        if let firstAQI = cityData.record.first?.date {
            startDate = NSInteger(round(firstAQI.timeIntervalSince1970))
        }
        for data in cityData.record {
            AQIPoints.append(data.aqiValue)
        }
        
    }
    
    func setupChart() {
        chartView.plugins = ["series-label"]

        let options = HIOptions()
        
        let chart = HIChart()
        chart.type = "spline"
        chart.scrollablePlotArea = HIScrollablePlotArea()
        chart.scrollablePlotArea.minWidth = 500
        chart.scrollablePlotArea.scrollPositionX = 1
        options.chart = chart
        
        let title = HITitle()
        title.text = ""
        title.align = "left"
        options.title = title
        
        let xAxis = HIXAxis()
        xAxis.type = "datetime"
        xAxis.labels = HILabels()
        xAxis.labels.overflow = "justify"
        options.xAxis = [xAxis]
        
        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.title.text = "AQI"
        yAxis.minorGridLineWidth = 0
        yAxis.allowDecimals = 2
        yAxis.gridLineWidth = 0
        
        let good = HIPlotBands()
        good.from = 0
        good.to = 50
        good.color = HIColor(hexValue: "85B368")
        good.label = HILabel()
        good.label.text = "Good"
        good.label.style = HICSSObject()
        good.label.style.color = "#606060"
        
        let satisfactory = HIPlotBands()
        satisfactory.from = 51
        satisfactory.to = 100
        satisfactory.color = HIColor(hexValue: "ADC75C")
        satisfactory.label = HILabel()
        satisfactory.label.text = "Satisfactory"
        satisfactory.label.style = HICSSObject()
        satisfactory.label.style.color = "#606060"
        
        let moderate = HIPlotBands()
        moderate.from = 101
        moderate.to = 200
        moderate.color = HIColor(hexValue: "FDF84C")
        moderate.label = HILabel()
        moderate.label.text = "Moderate"
        moderate.label.style = HICSSObject()
        moderate.label.style.color = "#606060"
        
        let poor = HIPlotBands()
        poor.from = 201
        poor.to = 300
        poor.color = HIColor(hexValue: "DD9B3E")
        poor.label = HILabel()
        poor.label.text = "Poor"
        poor.label.style = HICSSObject()
        poor.label.style.color = "#606060"
        
        let veryPoor = HIPlotBands()
        veryPoor.from = 301
        veryPoor.to = 400
        veryPoor.color = HIColor(hexValue: "CA4137")
        veryPoor.label = HILabel()
        veryPoor.label.text = "Very Poor"
        veryPoor.label.style = HICSSObject()
        veryPoor.label.style.color = "#606060"
        
        let severe = HIPlotBands()
        severe.from = 401
        severe.to = 500
        severe.color = HIColor(hexValue: "963129")
        severe.label = HILabel()
        severe.label.text = "Severe"
        severe.label.style = HICSSObject()
        severe.label.style.color = "#606060"
        
        yAxis.plotBands = [good, satisfactory, moderate, poor, veryPoor, severe]
        options.yAxis = [yAxis]
        
        let tooltip = HITooltip()
        tooltip.valueSuffix = " AQI"
        tooltip.valueDecimals = 2
        tooltip.xDateFormat = " "
        options.tooltip = tooltip
        
        let plotOptions = HIPlotOptions()
        plotOptions.spline = HISpline()
        plotOptions.spline.lineWidth = 4
        plotOptions.spline.states = HIStates()
        plotOptions.spline.states.hover = HIHover()
        plotOptions.spline.states.hover.lineWidth = 5
        plotOptions.spline.marker = HIMarker()
        plotOptions.spline.marker.enabled = false
        plotOptions.spline.pointInterval = 30000 // 30 seconds interval
        plotOptions.spline.pointStart = startDate as NSNumber?
        options.plotOptions = plotOptions
        
        let city = HISpline()
        city.name = cityName.text! + " AQI"
        city.data = AQIPoints
        
        options.series = [city]
        let exporting = HIExporting()
        exporting.enabled = false
        options.exporting = exporting
        chartView.showLoading("Loading...")

        chartView.options = options
    }
    
    

}

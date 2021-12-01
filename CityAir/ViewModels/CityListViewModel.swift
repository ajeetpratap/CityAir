//
//  CityListViewModel.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 28/11/21.
//

import Foundation


protocol ObservableCityListProtocol {
    func setError(_ message: String)
    var publishCityData: CityObserver<CityDataObject?> {get set}
    var publishCityListData: CityObserver<[CityDataObject]> {get set}
    var errorMessage: CityObserver<String?> {get set}
    var error: CityObserver<Bool> {get set}
}

class CityListViewModel: ObservableCityListProtocol {
    var errorMessage: CityObserver<String?> = CityObserver(nil)
    var cityName: String = ""
    var timer: Timer?
    var error: CityObserver<Bool> = CityObserver(false)
    var cityListData: [CityDataObject] = []
    var publishCityData: CityObserver<CityDataObject?> = CityObserver(nil)
    var publishCityListData: CityObserver<[CityDataObject]> = CityObserver([])
    var cityAirService: CityAirService?
    
    init(cityAirService: CityAirService) {
        self.cityAirService = cityAirService
        self.cityAirService?.delegate = self
    }
    
    func connect() {
        cityAirService?.connect()
    }
    
    func subscribeTo(city: String) {
        self.cityName = city
        startTimer()
    }
    
    func unsubscribe() {
        self.cityName = ""
        stopTimer()
    }
    
    func disconnect() {
        cityAirService?.disconnect()
    }
    
    func setError(_ message: String) {
        self.errorMessage = CityObserver(message)
        self.error = CityObserver(true)
    }
    
    func startTimer() {
        timer = Timer(timeInterval: 30.0, target: self, selector: #selector(fireCityData), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    @objc func fireCityData(timer: Timer) {
        let cityData = self.cityListData.filter { $0.name == self.cityName }
        if let data = cityData.last {
            publishCityData.value = data
        }
    }
}


extension CityListViewModel: CityAirServiceDelegate {
    func didReceive(response: Result<[AQIData], Error>) {
        switch response {
        case .success(let response):
            parseCityData(cityData: response)
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func parseCityData(cityData: [AQIData]) {
        if self.cityListData.count == 0 {
            for city in cityData {
                let data = CityDataObject(city: city.city)
                data.record.append(AQIDataModel(value: city.aqi, date: Date()))
                self.cityListData.append(data)
            }
        } else {
            for city in cityData {
                let matchedResult = self.cityListData.filter { $0.name == city.city }
                if let matchCity = matchedResult.first {
                    matchCity.record.append(AQIDataModel(value: city.aqi, date: Date()))
                } else {
                    let data = CityDataObject(city: city.city)
                    data.record.append(AQIDataModel(value: city.aqi, date: Date()))
                    self.cityListData.append(data)
                }
            }
        }
        self.publishCityListData.value = self.cityListData
    }
    
    func handleError(error: Error?) {
        if let _error = error {
            self.setError(_error.localizedDescription)
        }
    }
    
}

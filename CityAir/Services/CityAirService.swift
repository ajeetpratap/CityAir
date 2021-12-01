//
//  CityAirService.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 28/11/21.
//

import Foundation
import Starscream


protocol CityAirServiceDelegate {
    func didReceive(response: Result<[AQIData], Error>)
}


class CityAirService {
    var delegate: CityAirServiceDelegate?
    var timeInterval = 0
    var websocket: WebSocket? = {
        guard let url = URL(string: ServiceConstant.endpoint) else {
            print("error: \(ServiceConstant.endpoint)")
            return nil
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        var socket = WebSocket(request: request)
        return socket
    }()
    
    func connect() {
        self.websocket?.delegate = self
        self.websocket?.connect()
    }
    
    func disconnect() {
        self.websocket?.disconnect()
    }
    
    deinit {
        self.websocket?.disconnect()
        self.websocket = nil
    }
}



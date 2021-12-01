//
//  CityAirService+WebSocketDelegate.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 28/11/21.
//

import Starscream

extension CityAirService: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            case .connected(let headers):
                print("connected: \(headers)")
            case .disconnected(let error, let code):
                print("disconnected: \(error) with code: \(code)")
            case .text(let string):
                parseText(text: string)
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                print("Cancelled")
            case .error(let error):
                handleError(error: error)
            }
    }
    
    private func parseText(text: String) {
        let jsonData = Data(text.utf8)
        let decoder = JSONDecoder()
        do {
            let AQIData = try decoder.decode([AQIData].self, from: jsonData)
            self.delegate?.didReceive(response: .success(AQIData))
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func handleError(error: Error?) {
        if let _error = error {
            self.delegate?.didReceive(response: .failure(_error))
        }
    }
    
    
}

//
//  CityObserver.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 28/11/21.
//

import Foundation

final class CityObserver<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}

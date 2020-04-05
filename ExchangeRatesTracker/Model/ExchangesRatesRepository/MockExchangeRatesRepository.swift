//
//  MockExchangeRatesRepository.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation
import Combine

class MockExchangeRatesRepository: ExchangeRatesRepository {
    
    private let publisher = PassthroughSubject<[ExchangeRate], Never>()
    var exchangeRates: [ExchangeRate] = [ExchangeRate](repeating: ExchangeRate(baseCurrency: "EUR", counterCurrency: "CHF", exchangeRate: 1.21), count: 30)
    
    init() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { timer in
            self.getExchangeRates(onResult: { result in
                self.publisher.send(result)
            })
        }).fire()
    }
    
    
    func getExchangeRatesPublisher() -> AnyPublisher<[ExchangeRate], Never> {
        return publisher.eraseToAnyPublisher()
    }
    

    func getExchangeRates(onResult: @escaping ([ExchangeRate]) -> ()) {
        onResult(exchangeRates)
    }
        
    func getCurrencies() -> [String] {
        return ["EUR", "CHF", "USD", "GBP", "RUB", "JPY"]
    }
    
    func track(base: String, counter: String) {
        
    }
    
    func untrack(base: String, counter: String) {
        
    }
    
    func getRefCity(currency: String) -> RefCity? {
        return RefCity(name: "London", latitude: 1.0, longitude: 1.0)
    }
}

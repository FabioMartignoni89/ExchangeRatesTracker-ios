//
//  MockExchangeRatesRepository.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

class MockExchangeRatesRepository: ExchangeRatesRepository {
    var exchangeRates: [ExchangeRate] = [ExchangeRate](repeating: ExchangeRate(baseCurrency: "EUR", counterCurrency: "CHF", exchangeRate: 1.21), count: 30)

    func getExchangeRates(onResult: @escaping (Result<[ExchangeRate], Error>) -> ()) {
        onResult(.success(exchangeRates))
    }
        
    func getCurrencies() -> [String] {
        return ["EUR", "CHF", "USD", "GBP", "RUB", "JPY"]
    }
    
    func track(base: String, counter: String) {
        
    }
    
    func untrack(base: String, counter: String) {
        
    }
    
}

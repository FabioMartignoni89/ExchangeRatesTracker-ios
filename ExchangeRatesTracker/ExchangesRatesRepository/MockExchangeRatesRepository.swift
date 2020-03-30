//
//  MockExchangeRatesRepository.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

class MockExchangeRatesRepository: ExchangeRatesRepository {
   
    func getExchangeRates() -> [ExchangeRate] {
        return [ExchangeRate](repeating: ExchangeRate(currencyPair: CurrencyPair(baseCurrency: "EUR", counterCurrency: "CHF"), exchangeRate: 1.21), count: 30)
    }
    
    func getCurrencies() -> [String] {
        return ["EUR", "CHF", "USD", "GBP", "RUB", "JPY"]
    }
    
    func track(pair: CurrencyPair) {

    }
    
    func untrack(pair: CurrencyPair) {

    }
    
}

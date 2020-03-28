//
//  BaseExchangeRatesRepository.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

class BaseExchangeRatesRepository {
    
    let currenciesDataSource: CurrenciesDataSource
    private var trackedExchanges = [ExchangeRate]()
    
    init(currenciesDataSource: CurrenciesDataSource) {
        self.currenciesDataSource = currenciesDataSource
    }
}

extension BaseExchangeRatesRepository: ExchangeRatesRepository {
    
    
    
    func getTrackedExchanges() -> [ExchangeRate] {
        return trackedExchanges
    }
    
    func trackExchange(exchange: ExchangeRate) {
        trackedExchanges.append(exchange)
    }
}

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
    
    // MARK: private
    
    private func validateCurrencyPair(pair: CurrencyPair) -> Bool {
        let currencies = getAvailableCurrencies()
        return currencies.contains(pair.baseCurrency) &&
            currencies.contains(pair.baseCurrency) &&
            pair.baseCurrency != pair.counterCurrency
    }
    
    private func getAvailableCurrencies() -> [String] {
        do {
            return try currenciesDataSource.getCurrencies()
        }
        catch {
            print("Can't get currencies list. \(error)")
            return [String]()
        }
    }
    
}

extension BaseExchangeRatesRepository: ExchangeRatesRepository {
    
    func getTrackedExchanges() -> [ExchangeRate] {
        return trackedExchanges
    }
    
    func trackExchange(exchange: ExchangeRate) {
        if trackedExchanges.contains(where: { (ExchangeRate) -> Bool in
            exchange.currencyPair == ExchangeRate.currencyPair
        }) {
            return
        }
        
        if !validateCurrencyPair(pair: exchange.currencyPair) {
            return
        }
        
        trackedExchanges.append(exchange)
    }
}

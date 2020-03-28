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
    private var trackedPairs = [CurrencyPair]()
    
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
   
    func getExchangeRates() -> [ExchangeRate] {
        return trackedPairs.map { (CurrencyPair) -> ExchangeRate in
            ExchangeRate.init(currencyPair: CurrencyPair, exchangeRate: nil)
        }
    }
    
    func track(pair: CurrencyPair) {
        if trackedPairs.contains(pair) {
            return
        }
        
        if !validateCurrencyPair(pair: pair) {
            return
        }
        
        trackedPairs.append(pair)
    }
    
    func untrack(pair: CurrencyPair) {
        trackedPairs.removeAll { (CurrencyPair) -> Bool in
            CurrencyPair == pair
        }
    }
    
}

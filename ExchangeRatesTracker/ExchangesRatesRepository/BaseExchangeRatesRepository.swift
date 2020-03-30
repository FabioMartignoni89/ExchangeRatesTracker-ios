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
    let exchangeRatesPersistenceService: ExchangeRatesPersistenceService
    private var trackedPairs: [CurrencyPair]
    
    init(currenciesDataSource: CurrenciesDataSource, exchangeRatesPersistenceService: ExchangeRatesPersistenceService)  {
        self.currenciesDataSource = currenciesDataSource
        self.exchangeRatesPersistenceService = exchangeRatesPersistenceService
        do {
            self.trackedPairs = try exchangeRatesPersistenceService.loadTrackedCurrencyPairs()
        }
        catch {
            print(error.localizedDescription)
            self.trackedPairs = [CurrencyPair]()
        }
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
  
    private func saveTrackedPairs() {
        do {
            try exchangeRatesPersistenceService.saveTrackedCurrencyPairs(pairs: trackedPairs)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadTrackedPairs() {
        do {
            try exchangeRatesPersistenceService.saveTrackedCurrencyPairs(pairs: trackedPairs)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

extension BaseExchangeRatesRepository: ExchangeRatesRepository {    
   
    func getExchangeRates() -> [ExchangeRate] {
        return trackedPairs.map { (CurrencyPair) -> ExchangeRate in
            ExchangeRate.init(currencyPair: CurrencyPair, exchangeRate: nil)
        }
    }
    
    func getCurrencies() -> [String] {
        do {
            return try currenciesDataSource.getCurrencies()
        }
        catch {
            print(error.localizedDescription)
            return [String]()
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
        saveTrackedPairs()
    }
    
    func untrack(pair: CurrencyPair) {
        trackedPairs.removeAll { (CurrencyPair) -> Bool in
            CurrencyPair == pair
        }
        
        saveTrackedPairs()
    }
    
}

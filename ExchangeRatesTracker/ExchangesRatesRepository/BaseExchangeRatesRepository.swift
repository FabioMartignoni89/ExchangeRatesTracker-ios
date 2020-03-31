//
//  BaseExchangeRatesRepository.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

class BaseExchangeRatesRepository {
    
    let currenciesDataSource: ExchangeRatesDataSource
    let exchangeRatesPersistenceService: ExchangeRatesPersistenceService
    private var trackedPairs: [CurrencyPairDTO]
    
    init(currenciesDataSource: ExchangeRatesDataSource, exchangeRatesPersistenceService: ExchangeRatesPersistenceService)  {
        self.currenciesDataSource = currenciesDataSource
        self.exchangeRatesPersistenceService = exchangeRatesPersistenceService
        do {
            self.trackedPairs = try exchangeRatesPersistenceService.loadTrackedCurrencyPairs()
        }
        catch {
            print(error.localizedDescription)
            self.trackedPairs = [CurrencyPairDTO]()
        }
    }
    
    // MARK: private
    
    private func validateCurrencyPair(pair: CurrencyPairDTO) -> Bool {
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
        return trackedPairs.map { (currencyPair) -> ExchangeRate in
            ExchangeRate(baseCurrency: currencyPair.baseCurrency,
                              counterCurrency: currencyPair.counterCurrency,
                              exchangeRate: nil)
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
    
    func track(base: String, counter: String) {
        let newPair = CurrencyPairDTO(baseCurrency: base, counterCurrency: counter)
        
        if trackedPairs.contains(newPair) {
            return
        }
        
        if !validateCurrencyPair(pair: newPair) {
            return
        }
        
        trackedPairs.append(newPair)
        saveTrackedPairs()
    }
    
    func untrack(base: String, counter: String) {
        let newPair = CurrencyPairDTO(baseCurrency: base, counterCurrency: counter)

        trackedPairs.removeAll { (CurrencyPair) -> Bool in
            CurrencyPair == newPair
        }
        
        saveTrackedPairs()
    }
    
}

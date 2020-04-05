//
//  BaseExchangeRatesRepository.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

class BaseExchangeRatesRepository: ObservableObject {
    let dataSource: ExchangeRatesDataSource
    let persistenceService: ExchangeRatesPersistenceService
    private var trackedPairs: [CurrencyPairDTO]
    let refreshInterval = 1
    
    init(currenciesDataSource: ExchangeRatesDataSource, exchangeRatesPersistenceService: ExchangeRatesPersistenceService)  {
        self.dataSource = currenciesDataSource
        self.persistenceService = exchangeRatesPersistenceService
        
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
            return try dataSource.getCurrencies()
        }
        catch {
            print("Can't get currencies list. \(error)")
            return [String]()
        }
    }
  
    private func saveTrackedPairs() {
        do {
            try persistenceService.saveTrackedCurrencyPairs(pairs: trackedPairs)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadTrackedPairs() {
        do {
            try persistenceService.saveTrackedCurrencyPairs(pairs: trackedPairs)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

extension BaseExchangeRatesRepository: ExchangeRatesRepository {    
   
    func getExchangeRates(onResult: @escaping ([ExchangeRate]) -> ()) {
        let pairs: [String] = trackedPairs.map { pair in
            return "\(pair.baseCurrency)\(pair.counterCurrency)"
        }
        
        dataSource.fetchExchangeRates(currencyPairs: pairs) { result in
            
            var newExchangeRates = [ExchangeRate]()
            for index in 0..<pairs.count {
                let rate = ExchangeRate(baseCurrency: self.trackedPairs[index].baseCurrency,
                                        counterCurrency: self.trackedPairs[index].counterCurrency,
                                        exchangeRate: nil)
                newExchangeRates.append(rate)
            }
            
            switch result {
                case let .failure(error):
                    print(error.localizedDescription)
                    break

                case let .success(data):
                    for index in 0..<pairs.count {
                        newExchangeRates[index].exchangeRate = data[index]
                    }
                    print("\(pairs.count) exchange rates retrieved")
                    break;
            }
            
            onResult(newExchangeRates)
        }
    }
    
    func getCurrencies() -> [String] {
        do {
            return try dataSource.getCurrencies()
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
        print("\(base)/\(counter) tracked")
    }
    
    func untrack(base: String, counter: String) {
        let newPair = CurrencyPairDTO(baseCurrency: base, counterCurrency: counter)

        trackedPairs.removeAll { (CurrencyPair) -> Bool in
            CurrencyPair == newPair
        }
            
        saveTrackedPairs()
        print("\(base)/\(counter) untracked")
    }
    
}

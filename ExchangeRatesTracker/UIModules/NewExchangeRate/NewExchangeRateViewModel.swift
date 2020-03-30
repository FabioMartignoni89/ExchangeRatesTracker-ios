//
//  NewExchangeRateViewModel.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation
import Combine

protocol NewExchangeRateViewModel {
    func trackNewExchangeRate(baseCurrency: String, counterCurrency: String)
}

final class BaseNewExchangeRateViewModel: ObservableObject {
    @Published var currencies: [String]
    
    private let repository: ExchangeRatesRepository
    
    init(repository: ExchangeRatesRepository) {
        self.repository = repository
        
        do {
            self.currencies = try repository.getCurrencies()
        }
        catch {
            print(error)
            self.currencies = ["-"]
            // TODO: show error message
        }
    }
}

extension BaseNewExchangeRateViewModel: NewExchangeRateViewModel {
    func trackNewExchangeRate(baseCurrency: String, counterCurrency: String) {
        let newPair = CurrencyPair(baseCurrency: baseCurrency, counterCurrency: counterCurrency)
        do {
            try  repository.track(pair: newPair)
        }
        catch {
            print(error.localizedDescription) //TODO: user error message
        }
    }
}

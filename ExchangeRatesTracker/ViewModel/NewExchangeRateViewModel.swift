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
        self.currencies = repository.getCurrencies()        
    }
}

extension BaseNewExchangeRateViewModel: NewExchangeRateViewModel {
    func trackNewExchangeRate(baseCurrency: String, counterCurrency: String) {
        repository.track(base: baseCurrency, counter: counterCurrency)
    }
}

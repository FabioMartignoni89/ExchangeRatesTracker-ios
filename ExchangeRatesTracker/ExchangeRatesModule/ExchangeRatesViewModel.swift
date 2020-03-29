//
//  ExchangeRatesViewModel.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation
import Combine

protocol ExchangeRatesViewModel {
    // observables
    var exchangeRates: [ExchangeRate] { get }
    
    // view events
    func onViewReady()
}

final class BaseExchangeRatesViewModel: ObservableObject {
    @Published var exchangeRates = [ExchangeRate]()
    
    private let repository: ExchangeRatesRepository
    
    init(repository: ExchangeRatesRepository) {
        self.repository = repository
        exchangeRates.append(ExchangeRate(currencyPair: CurrencyPair(baseCurrency: "EUR", counterCurrency: "USD"), exchangeRate: 1.23))
        exchangeRates.append(ExchangeRate(currencyPair: CurrencyPair(baseCurrency: "CHF", counterCurrency: "USD"), exchangeRate: 1.71))
    }
}

extension BaseExchangeRatesViewModel: ExchangeRatesViewModel {
    
    func onViewReady() {

    }
}

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
    var exchangeRates: [ExchangeRate] { get }
    func fetchExchanges()
    func untrackExchangeRate(exchange: ExchangeRate)
}

final class BaseExchangeRatesViewModel: ObservableObject {
    @Published var exchangeRates = [ExchangeRate]()
    
    private let repository: ExchangeRatesRepository
    
    init(repository: ExchangeRatesRepository) {
        self.repository = repository
        fetchExchanges()
    }
}

extension BaseExchangeRatesViewModel: ExchangeRatesViewModel {
    func fetchExchanges() {
        exchangeRates = repository.getExchangeRates()
    }
    
    func untrackExchangeRate(exchange: ExchangeRate) {
        do {
            try repository.untrack(pair: exchange.currencyPair)
        }
        catch {
            print(error.localizedDescription) //TODO: user error message
        }
        fetchExchanges()
    }
}

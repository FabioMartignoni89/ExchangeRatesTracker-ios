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
    func untrackExchangeRate(exchange: ExchangeRate)
}

final class BaseExchangeRatesViewModel: ObservableObject {
    @Published var exchangeRates = [ExchangeRate]()
    
    private let repository: ExchangeRatesRepository
    private let refreshInterval = 1
    
    init(repository: ExchangeRatesRepository) {
        self.repository = repository
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(refreshInterval), repeats: true, block: { timer in
            self.fetchExchangeRates()
        }).fire()
    }
    
    private func fetchExchangeRates() {
        repository.getExchangeRates() { result in
            switch result {
                case let .failure(error):
                    print(error.localizedDescription)
                    break

                case let .success(data):
                    DispatchQueue.main.async {
                        self.exchangeRates = data
                    }
                    break
            }
        }
    }
}

extension BaseExchangeRatesViewModel: ExchangeRatesViewModel {
    
    func untrackExchangeRate(exchange: ExchangeRate) {
        repository.untrack(base: exchange.baseCurrency, counter: exchange.counterCurrency)
    }
}

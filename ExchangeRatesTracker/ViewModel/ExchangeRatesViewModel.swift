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
    var exchangeRates: [ExchangeRateDisplayModel] { get }
    func untrackExchangeRate(index: Int)
}

final class BaseExchangeRatesViewModel: ObservableObject {
    var exchangeRatesModels = [ExchangeRate]()
    @Published var exchangeRates = [ExchangeRateDisplayModel]()
    
    private let repository: ExchangeRatesRepository
    private let refreshInterval = 1
    
    init(repository: ExchangeRatesRepository) {
        self.repository = repository
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(refreshInterval), repeats: true, block: { timer in
            self.fetchExchangeRates()
        }).fire()
    }
    
    private func fetchExchangeRates() {
        repository.getExchangeRates() { newExchangeRates in
            DispatchQueue.main.async {
                self.exchangeRatesModels = newExchangeRates
                
                if self.exchangeRates.count != self.exchangeRatesModels.count {
                    self.refreshDisplayRates()
                }
                else {
                    self.refreshDisplayRatesValues()
                }
            }
        }
    }
    
    private func refreshDisplayRates() {
        var newRates = [ExchangeRateDisplayModel]()
        for exchangeRate in exchangeRatesModels {
            newRates.append(ExchangeRateDisplayModel(baseCurrency: exchangeRate.baseCurrency,
                                                     counterCurrency: exchangeRate.counterCurrency,
                                                     exchangeValue: ""))
        }
        
        exchangeRates = newRates
        refreshDisplayRatesValues()
    }
    
    private func refreshDisplayRatesValues() {
        for index in 0..<exchangeRatesModels.count {
            exchangeRates[index].exchangeValue = exchangeRatesModels[index].exchangeRate != nil ? "\(exchangeRatesModels[index].exchangeRate!)" : "-"
        }
    }
}

extension BaseExchangeRatesViewModel: ExchangeRatesViewModel {
    
    func untrackExchangeRate(index: Int) {
        let exchange = exchangeRates[index]
        repository.untrack(base: exchange.baseCurrency, counter: exchange.counterCurrency)
    }
}

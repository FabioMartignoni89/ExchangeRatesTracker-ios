//
//  ExchangeRateMapViewModel.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 05/04/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation
import Combine

protocol ExchangeRateMapViewModel {
    var mapAnnotation: RefCityAnnotation? { get }
}

final class BaseExchangeRateMapViewModel: ObservableObject {
    private let repository: ExchangeRatesRepository
    private let refreshInterval = 1
    
    private let baseCurrency: String
    private let counterCurrency: String
    var exchangeRate: Double? = nil
    var refCity: RefCity?
    @Published var mapAnnotation: RefCityAnnotation?
    
    init(repository: ExchangeRatesRepository, baseCurrency: String, counterCurrency: String) {
        self.repository = repository
        self.baseCurrency = baseCurrency
        self.counterCurrency = counterCurrency
        refCity = getRefCity(currency: baseCurrency)
        
        setupAnnotation()
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(refreshInterval), repeats: true, block: { timer in
            self.fetchExchangeRates()
        }).fire()
    }
    
    private func fetchExchangeRates() {
        repository.getExchangeRates() { newExchangeRates in
            DispatchQueue.main.async {
                let match = newExchangeRates.first() { newRate -> Bool in
                    return newRate.baseCurrency == self.baseCurrency &&
                        newRate.counterCurrency == self.counterCurrency
                }
                
                if match != nil {
                    self.exchangeRate = match!.exchangeRate

                    if self.mapAnnotation == nil {
                        self.setupAnnotation()
                    }
                    else {
                        self.refreshDisplayRate()
                    }
                }
            }
        }
    }
    
    private func getRefCity(currency: String) -> RefCity {
        return RefCity(name: "London", latitude: 1.0, longitude: 1.0)
    }
    
    private func setupAnnotation() {
        if let city = refCity {
            self.mapAnnotation = RefCityAnnotation(city: city.name,
                                                   exchangeRate: "-",
                                                   latitude: city.latitude,
                                                   longitude: city.longitude)
            refreshDisplayRate()
        }
    }
    
    private func refreshDisplayRate() {
        if let annotation = mapAnnotation {
            let rate = exchangeRate != nil ? "\(exchangeRate!)" : "-"
            annotation.exchangeRate = "\(baseCurrency)/\(counterCurrency) = \(rate)"
        }
    }
}

extension BaseExchangeRateMapViewModel: ExchangeRateMapViewModel {
    
}

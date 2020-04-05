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
    
    private var subscriber: AnyCancellable? = nil
    
    init(repository: ExchangeRatesRepository, baseCurrency: String, counterCurrency: String) {
        self.repository = repository
        self.baseCurrency = baseCurrency
        self.counterCurrency = counterCurrency
        refCity = repository.getRefCity(currency: baseCurrency)
        
        setupAnnotation()
        
        subscriber = repository
            .getExchangeRatesPublisher()
            .sink(receiveValue: { newExchangeRates in
                
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
        })
    }
    
    private func setupAnnotation() {
        if let city = refCity {
            self.mapAnnotation = RefCityAnnotation(city: city.name,
                                                   exchangeRate: "-",
                                                   latitude: city.latitude,
                                                   longitude: city.longitude)
            refreshDisplayRate()
        }
        else {
            print("Ref city not found for currency \(baseCurrency).")
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

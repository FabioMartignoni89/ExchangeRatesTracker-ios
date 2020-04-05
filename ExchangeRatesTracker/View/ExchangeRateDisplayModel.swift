//
//  ExchangeRateDisplayModel.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 05/04/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation
import Combine

class ExchangeRateDisplayModel: Identifiable, ObservableObject{
    var id = UUID()
    let baseCurrency: String
    let counterCurrency: String
    @Published var exchangeValue: String
    
    init(baseCurrency: String, counterCurrency: String, exchangeValue: String) {
        self.baseCurrency = baseCurrency
        self.counterCurrency = counterCurrency
        self.exchangeValue = exchangeValue
    }
}

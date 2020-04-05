//
//  ExchangeRatesPersistenceService.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 30/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

protocol ExchangeRatesPersistenceService {
    func saveTrackedCurrencyPairs(pairs: [CurrencyPairDTO]) throws
    func loadTrackedCurrencyPairs() throws -> [CurrencyPairDTO]
}

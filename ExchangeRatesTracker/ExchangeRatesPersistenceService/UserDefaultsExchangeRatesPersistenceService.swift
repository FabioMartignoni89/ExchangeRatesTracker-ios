//
//  UserDefaultsExchangeRatesPersistenceService.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 30/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

class UserDefaultsExchangeRatesPersistenceService {
    private var userDefaults: UserDefaults
    private let TRACKED_CURRENCY_PAIRS_KEY = "TRACKED_CURRENCY_PAIRS_KEY"

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

extension UserDefaultsExchangeRatesPersistenceService: ExchangeRatesPersistenceService {
    func saveTrackedCurrencyPairs(pairs: [CurrencyPair]) throws {
        try userDefaults.set(type: CurrencyPair.self, values: pairs, forKey: TRACKED_CURRENCY_PAIRS_KEY)
    }
    
    func loadTrackedCurrencyPairs() throws -> [CurrencyPair] {
        return try userDefaults.objects(type: CurrencyPair.self, forKey: TRACKED_CURRENCY_PAIRS_KEY)
    }
}

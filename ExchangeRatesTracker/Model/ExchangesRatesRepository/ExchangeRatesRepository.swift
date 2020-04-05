//
//  ExchangeRatesRepository.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

public protocol ExchangeRatesRepository {
    
    /**
     Get  the tracked exchanges.
     - returns: an array of exchange rates
     */
    func getExchangeRates(onResult: @escaping ([ExchangeRate]) -> ())

    /**
     Get  the available currencies.
     - returns: an array of currency codes
     */
    func getCurrencies() -> [String]
    
    /**
     Track a valid new currency pair.
     - parameters:
        - base: the base currency
        - counter: the counter currency
     */
    func track(base: String, counter: String)
    
    /**
     Untrack a currency pair.
     - parameters:
         - base: the base currency
         - counter: the counter currency
     */
    func untrack(base: String, counter: String)
}

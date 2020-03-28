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
     - returns: an array of exchanges
     */
    func getExchangeRates() -> [ExchangeRate]
    
    /**
     Track an exchange rate.
     - parameters:
         - pair: the currency pair to track
     */
    func track(pair: CurrencyPair)
}

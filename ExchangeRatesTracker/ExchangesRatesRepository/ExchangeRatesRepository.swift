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
    func getTrackedExchanges() -> [ExchangeRate]
    
    /**
     Track an exchange rate if not tracked yet.
     - parameters:
         - exchange: the exchange rate to track
     */
    func trackExchange(exchange: ExchangeRate)
}

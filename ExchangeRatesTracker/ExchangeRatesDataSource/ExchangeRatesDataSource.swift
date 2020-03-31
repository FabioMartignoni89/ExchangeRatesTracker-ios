//
//  ExchangeRatesDataSource.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 27/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

public protocol ExchangeRatesDataSource {
    
    /**
     Get all the available currencies.
     - returns: an array of currency codes
     */
    func getCurrencies() throws -> [String]
}

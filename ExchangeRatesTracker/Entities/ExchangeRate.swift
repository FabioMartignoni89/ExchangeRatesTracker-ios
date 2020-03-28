//
//  Exchange.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

public struct ExchangeRate: Equatable {
    let currencyPair: CurrencyPair
    let exchangeRate: Double?
}

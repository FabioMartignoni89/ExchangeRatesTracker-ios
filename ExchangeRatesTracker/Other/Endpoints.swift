//
//  Endpoints.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 31/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

struct Endpoints {
    // https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios?pairs=EURCHF
    static func fetchExchangeRates(currencyPairs: [String]) -> URL? {
        var components = URLComponents()
           components.scheme = "https"
           components.host = "europe-west1-revolut-230009.cloudfunctions.net"
           components.path = "/revolut-ios"
        components.queryItems = currencyPairs.map({ pair in
            return URLQueryItem(name: "pairs", value: pair)
        })
        
        return components.url
    }
}

//
//  JSONCurrenciesDataSource.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 27/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

public class JSONCurrenciesDataSource {
    
    private let json: String
    private var currenciesDTO: CurrenciesDTO?
    
    init(json: String) {
        self.json = json
    }
    
    private func getCurrenciesDTO() throws -> CurrenciesDTO {
        
        if currenciesDTO == nil { // lazy
            currenciesDTO = try JSONDecoder().decode(CurrenciesDTO.self, from: Data(json.utf8))
        }
        
        guard let dto = currenciesDTO else {
            throw JSONDataIsNil(description: "Error decoding JSON: \(json)")
        }
        
        return dto
    }
}

extension JSONCurrenciesDataSource: CurrenciesDataSource {
    
    public func getCurrencies() throws -> [String] {
        return try getCurrenciesDTO().worldCurrencies.map { currency in
            return currency.currency
        }
    }
}

// MARK: currencies JSON DTO mapping

private struct CurrenciesDTO: Codable {
    let worldCurrencies: [WorldCurrency]

    enum CodingKeys: String, CodingKey {
        case worldCurrencies = "world_currencies"
    }
}

private struct WorldCurrency: Codable {
    let currency: String
    let city: City
}

private struct City: Codable {
    let name: String
    let lat, lon: Double
}

// MARK: errors

struct JSONDataIsNil: LocalizedError {

    var errorDescription: String? { return _description }

    private var _description: String

    init(description: String) {
        self._description = description
    }
}

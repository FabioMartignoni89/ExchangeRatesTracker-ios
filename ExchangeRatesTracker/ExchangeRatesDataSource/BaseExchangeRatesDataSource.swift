//
//  BaseExchangeRatesDataSource.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 27/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

public class BaseExchangeRatesDataSource {
    
    private let currenciesFileName: String
    private var currenciesDTO: CurrenciesDTO?
    
    init(fileName: String) {
        self.currenciesFileName = fileName
    }
    
    private func getCurrenciesDTO() throws -> CurrenciesDTO {
        
        if currenciesDTO == nil { // lazy
            currenciesDTO = try Bundle.main.loadJSON(type: CurrenciesDTO.self, fileName: currenciesFileName)
        }
        
        guard let dto = currenciesDTO else {
            throw JSONDataIsNil(description: "Error decoding JSON: \(currenciesFileName)")
        }
        
        return dto
    }
}

extension BaseExchangeRatesDataSource: ExchangeRatesDataSource {
    
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

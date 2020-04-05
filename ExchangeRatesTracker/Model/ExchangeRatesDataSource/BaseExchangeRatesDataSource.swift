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
    let session = URLSession.shared

    init(fileName: String) {
        self.currenciesFileName = fileName
    }
    
    private func getCurrenciesDTO() throws -> CurrenciesDTO {
        
        if currenciesDTO == nil { // lazy
            currenciesDTO = try Bundle.main.loadJSON(type: CurrenciesDTO.self, fileName: currenciesFileName)
        }
        
        guard let dto = currenciesDTO else {
            throw ExchangeRatesDataSourceError.jsonParsingError(description: "Error decoding JSON: \(currenciesFileName)")
        }
        
        return dto
    }
}

extension BaseExchangeRatesDataSource: ExchangeRatesDataSource {
    
    public func getRefCity(currency: String) -> RefCity? {
        if let currencyDTO = try? getCurrenciesDTO().worldCurrencies.first(where: { (WorldCurrency) -> Bool in
            WorldCurrency.currency == currency
        }) {
            let cityDTO = currencyDTO.city
            return RefCity(name: cityDTO.name, latitude: cityDTO.lat, longitude: cityDTO.lon)
        }
            
        return nil
    }
    
    public func getCurrencies() throws -> [String] {
        return try getCurrenciesDTO().worldCurrencies.map { currency in
            return currency.currency
        }
    }
    
    public func fetchExchangeRates(currencyPairs: [String], onResult: @escaping (Result<[Double], Error>) -> ()) {
        guard let url = Endpoints.fetchExchangeRates(currencyPairs: currencyPairs) else {
            onResult(.failure(ExchangeRatesDataSourceError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { result, response, error in
            
            if let error = error {
               onResult(.failure(error))
               return
            }

            guard let response = response as? HTTPURLResponse else {
                onResult(.failure(ExchangeRatesDataSourceError.dataIsMissingError))
                return
            }
             
            if !(200...299).contains(response.statusCode) {
                onResult(.failure(ExchangeRatesDataSourceError.serverError(code: response.statusCode, error: error)))
                return
            }
                
            guard let jsonData = result else {
                onResult(.failure(ExchangeRatesDataSourceError.dataIsMissingError))
                return
            }
            
            do {
                guard let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSMutableDictionary else {
                    onResult(.failure(ExchangeRatesDataSourceError.jsonParsingError(description: "Failed to parse JSON")))
                    return
                }
                
                let exchangeRates = try currencyPairs.map { (pair: String) throws -> Double in
                    if let rate = jsonDict[pair] as? Double {
                        return rate
                    }
                    else {
                        throw ExchangeRatesDataSourceError.jsonParsingError(description: "Error converting currencypair to double")
                    }
                }
                
                onResult(.success(exchangeRates))
            }
            catch {
                onResult(.failure(ExchangeRatesDataSourceError.jsonParsingError(description: error.localizedDescription)))
                return
            }
        }
        
        task.resume()
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

public enum ExchangeRatesDataSourceError: LocalizedError
{
    case serverError(code: Int, error: Error?)
    case dataIsMissingError
    case jsonParsingError(description: String)
    case invalidURL
    
    public var errorDescription: String? {
        
        switch self {
        
        case let .jsonParsingError(description):
                return description
            
            case let .serverError(code, error):
                return "Code: '\(code)'. Error: '\(String(describing: error))'"
            
        case .dataIsMissingError, .invalidURL:
                return self.localizedDescription
        }
    }
}

//
//  ExchangeRatesBuilder.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

class ExchangeRatesBuilder {
    
    static let CURRENCIES_FILE_NAME = "currencies"
    
    class func build() -> ExchangeRatesView {
        var JSONString: String
        do {
            JSONString = try Bundle.main.loadJSON(fileName: CURRENCIES_FILE_NAME)
        }
        catch {
            print(error)
            JSONString = ""
        }
        
        let currenciesDataSource = JSONCurrenciesDataSource(json: JSONString)
        let repository = BaseExchangeRatesRepository(currenciesDataSource: currenciesDataSource)
        let viewModel = BaseExchangeRatesViewModel(repository: repository)
        let contentView = ExchangeRatesView(viewModel: viewModel)

        return contentView
    }
}

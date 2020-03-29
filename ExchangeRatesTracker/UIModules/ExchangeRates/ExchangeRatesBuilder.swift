//
//  ExchangeRatesBuilder.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

class ExchangeRatesBuilder {
        
    class func build() -> ExchangeRatesView {
        let currenciesDataSource = BundleCurrenciesDataSource(fileName: Configs.CURRENCIES_FILE_NAME)
        let repository = BaseExchangeRatesRepository(currenciesDataSource: currenciesDataSource)
        let viewModel = BaseExchangeRatesViewModel(repository: repository)
        let contentView = ExchangeRatesView(viewModel: viewModel)

        return contentView
    }
}

//
//  NewExchangeRateBuilder.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

class NewExchangeRateBuilder {
        
    class func build() -> NewExchangeRateView {
        let currenciesDataSource = BundleCurrenciesDataSource(fileName: Configs.CURRENCIES_FILE_NAME)
        let repository = BaseExchangeRatesRepository(currenciesDataSource: currenciesDataSource)
        let viewModel = BaseNewExchangeRateViewModel(repository: repository)
        let contentView = NewExchangeRateView(viewModel: viewModel)

        return contentView
    }
}

//
//  ExchangeRatesRouter.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation


protocol ViewProvider {
 
    func provideExchangeRates() -> ExchangeRatesView
    func provideNewExchangeRate() -> NewExchangeRateView
}

class BaseViewProvider {

    let exchangeRatesRepository: ExchangeRatesRepository
    
    init() {
        let persistenceService = UserDefaultsExchangeRatesPersistenceService(userDefaults: UserDefaults.standard)
        let currenciesDataSource = BundleCurrenciesDataSource(fileName: Configs.CURRENCIES_FILE_NAME)
        exchangeRatesRepository = BaseExchangeRatesRepository(currenciesDataSource: currenciesDataSource,
                                                              exchangeRatesPersistenceService: persistenceService)
    }
}

extension BaseViewProvider: ViewProvider {
    
    func provideExchangeRates() -> ExchangeRatesView {
        let viewModel = BaseExchangeRatesViewModel(repository: exchangeRatesRepository)
        return ExchangeRatesView(viewModel: viewModel, viewProvider: self)
    }
    
    func provideNewExchangeRate() -> NewExchangeRateView {
        let viewModel = BaseNewExchangeRateViewModel(repository: exchangeRatesRepository)
        return NewExchangeRateView(viewModel: viewModel)
    }
}

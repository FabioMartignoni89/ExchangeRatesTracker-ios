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
    func provideExchangeRateMap(baseCurrency: String, counterCurrency: String) -> ExchangeRateMapView
}

class BaseViewProvider {

    // the app single instance of ExchangeRatesRepository
    let exchangeRatesRepository: ExchangeRatesRepository
    
    init() {
        let persistenceService = UserDefaultsExchangeRatesPersistenceService(userDefaults: UserDefaults.standard)
        let currenciesDataSource = BaseExchangeRatesDataSource(fileName: Configs.CURRENCIES_FILE_NAME)
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
    
    func provideExchangeRateMap(baseCurrency: String, counterCurrency: String) -> ExchangeRateMapView {
        let viewModel = BaseExchangeRateMapViewModel(repository: exchangeRatesRepository,
                                                     baseCurrency: baseCurrency,
                                                     counterCurrency: counterCurrency)
        return ExchangeRateMapView(viewModel: viewModel)
    }
}

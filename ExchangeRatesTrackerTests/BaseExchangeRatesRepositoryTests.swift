//
//  BaseExchangeRatesRepositoryTests.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import XCTest

class BaseExchangeRatesRepositoryTests: XCTestCase {
    
    var repo: ExchangeRatesRepository?

    override func setUp() {
        repo = BaseExchangeRatesRepository(currenciesDataSource: MockCurrenciesDataSource())
    }
    
    func testZeroExchangesInitiallyReturned() {
        XCTAssertEqual(0 , repo!.getTrackedExchanges().count, "No exchanges should be returned initially.")
    }
    
    func testCanTrackExchanges() {
        let EURCHF = CurrencyPair(baseCurrency: "EUR", counterCurrency: "CHF")
        let exchange = ExchangeRate(currencyPair: EURCHF, exchangeRate: 1.0)
        for _ in 0...3 {
            repo!.trackExchange(exchange: exchange)
        }

        XCTAssertEqual(4 , repo!.getTrackedExchanges().count, "4 exchanges should be tracked.")
    }
}

class MockCurrenciesDataSource: CurrenciesDataSource {
    func getCurrencies() throws -> [String] {
        return ["EUR", "CHF", "USD", "GBP", "RUB", "JPY"]
    }
}

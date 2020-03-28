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
    
    let EURCHF = ExchangeRate(currencyPair: CurrencyPair(baseCurrency: "EUR", counterCurrency: "CHF"), exchangeRate: 1.0)
    let CHFEUR = ExchangeRate(currencyPair: CurrencyPair(baseCurrency: "CHF", counterCurrency: "EUR"), exchangeRate: 1.0)

    override func setUp() {
        repo = BaseExchangeRatesRepository(currenciesDataSource: MockCurrenciesDataSource())
    }
    
    func testZeroExchangesInitiallyReturned() {
        XCTAssertEqual(0 , repo!.getTrackedExchanges().count, "No exchanges should be returned initially.")
    }
    
    func testCanTrackExchangeRates() {
        repo!.trackExchange(exchange: EURCHF)
        repo!.trackExchange(exchange: CHFEUR)
        XCTAssertEqual(2 , repo!.getTrackedExchanges().count)
    }
    
    func testAvoidTrackingDuplications() {
        repo!.trackExchange(exchange: EURCHF)
        repo!.trackExchange(exchange: EURCHF)
        repo!.trackExchange(exchange: CHFEUR)
        XCTAssertEqual(2 , repo!.getTrackedExchanges().count, "The same exchange rate is being tracked multiple times.")
    }
    
    func testAvoidTrackingOfInvalidCurrencyPairs() {
        repo!.trackExchange(exchange: ExchangeRate(currencyPair: CurrencyPair(baseCurrency: "CHF", counterCurrency: "CHF"), exchangeRate: 1.0))
        repo!.trackExchange(exchange: ExchangeRate(currencyPair: CurrencyPair(baseCurrency: "", counterCurrency: "CHF"), exchangeRate: 1.0))
        XCTAssertEqual(0 , repo!.getTrackedExchanges().count, "An invalid exchange rate is being tracked.")
    }
}

// MARK: - Mocks

class MockCurrenciesDataSource: CurrenciesDataSource {
    func getCurrencies() throws -> [String] {
        return ["EUR", "CHF", "USD", "GBP", "RUB", "JPY"]
    }
}

//
//  BaseExchangeRatesRepositoryTests.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import XCTest

class BaseExchangeRatesRepositoryTests: XCTestCase {
    
    let mockUserDefaults = MockUserDefaults()
    let mockCurrenciesDataSource = MockCurrenciesDataSource()
    var repo: ExchangeRatesRepository?
    
    let EURCHF = CurrencyPair(baseCurrency: "EUR", counterCurrency: "CHF")
    let CHFEUR = CurrencyPair(baseCurrency: "CHF", counterCurrency: "EUR")

    override func setUp() {
        mockUserDefaults.reset()
        let persistenceService = UserDefaultsExchangeRatesPersistenceService(userDefaults: mockUserDefaults)
        repo = BaseExchangeRatesRepository(currenciesDataSource: mockCurrenciesDataSource,
                                           exchangeRatesPersistenceService: persistenceService)
    }
    
    func testZeroExchangesInitiallyReturned() {
        XCTAssertEqual(0 , repo!.getExchangeRates().count, "No exchanges should be tracked initially.")
    }
    
    func testCanTrackExchangeRates() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        XCTAssertEqual(2 , repo!.getExchangeRates().count)
    }
    
    func testAvoidTrackingDuplications() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        XCTAssertEqual(2 , repo!.getExchangeRates().count, "The same pair is being tracked multiple times.")
    }
    
    func testAvoidTrackingOfInvalidCurrencyPairs() {
        repo!.track(base: "CHF", counter: "CHF")
        repo!.track(base: "", counter: "CHF")
        XCTAssertEqual(0 , repo!.getExchangeRates().count, "An invalid pair is being tracked.")
    }
    
    func testCanUntrackCurrency() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")
        
        XCTAssertEqual(1 , repo!.getExchangeRates().count)
    }
    
    func testUntrackEmptyListDoesNothing() {
        repo!.untrack(base: "CHF", counter: "EUR")
        XCTAssertEqual(0 , repo!.getExchangeRates().count)
    }
    
    func testUntrackMoreThanOneTimeDoesNothing() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")
        XCTAssertEqual(1 , repo!.getExchangeRates().count)
    }
    
    func testCanGetCurrencies() {
        let currencies = repo!.getCurrencies()
        XCTAssertEqual(mockCurrenciesDataSource.hardCodedCurrencies.count, currencies.count)
    }
}

// MARK: - Mocks

class MockCurrenciesDataSource: CurrenciesDataSource {
    let hardCodedCurrencies = ["EUR", "CHF", "USD", "GBP", "RUB", "JPY"]
    
    func getCurrencies() throws -> [String] {
        return hardCodedCurrencies
    }
}

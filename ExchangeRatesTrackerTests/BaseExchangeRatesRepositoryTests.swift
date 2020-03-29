//
//  BaseExchangeRatesRepositoryTests.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import XCTest

class BaseExchangeRatesRepositoryTests: XCTestCase {
    
    let mockCurrenciesDataSource = MockCurrenciesDataSource()
    var repo: ExchangeRatesRepository?
    
    let EURCHF = CurrencyPair(baseCurrency: "EUR", counterCurrency: "CHF")
    let CHFEUR = CurrencyPair(baseCurrency: "CHF", counterCurrency: "EUR")

    override func setUp() {
        repo = BaseExchangeRatesRepository(currenciesDataSource: mockCurrenciesDataSource)
    }
    
    func testZeroExchangesInitiallyReturned() {
        XCTAssertEqual(0 , repo!.getExchangeRates().count, "No exchanges should be tracked initially.")
    }
    
    func testCanTrackExchangeRates() {
        repo!.track(pair: EURCHF)
        repo!.track(pair: CHFEUR)
        XCTAssertEqual(2 , repo!.getExchangeRates().count)
    }
    
    func testAvoidTrackingDuplications() {
        repo!.track(pair: EURCHF)
        repo!.track(pair: EURCHF)
        repo!.track(pair: CHFEUR)
        XCTAssertEqual(2 , repo!.getExchangeRates().count, "The same pair is being tracked multiple times.")
    }
    
    func testAvoidTrackingOfInvalidCurrencyPairs() {
        repo!.track(pair: CurrencyPair(baseCurrency: "CHF", counterCurrency: "CHF"))
        repo!.track(pair: CurrencyPair(baseCurrency: "", counterCurrency: "CHF"))
        XCTAssertEqual(0 , repo!.getExchangeRates().count, "An invalid pair is being tracked.")
    }
    
    func testCanUntrackCurrency() {
        repo!.track(pair: EURCHF)
        repo!.track(pair: CHFEUR)
        repo!.untrack(pair: CHFEUR)
        
        XCTAssertEqual(1 , repo!.getExchangeRates().count)
    }
    
    func testUntrackEmptyListDoesNothing() {
        repo!.untrack(pair: CHFEUR)
        XCTAssertEqual(0 , repo!.getExchangeRates().count)
    }
    
    func testUntrackMoreThanOneTimeDoesNothing() {
        repo!.track(pair: EURCHF)
        repo!.track(pair: CHFEUR)
        repo!.untrack(pair: CHFEUR)
        repo!.untrack(pair: CHFEUR)
        XCTAssertEqual(1 , repo!.getExchangeRates().count)
    }
    
    func testCanGetCurrencies() {
        do {
            let currencies = try repo!.getCurrencies()
            XCTAssertEqual(mockCurrenciesDataSource.hardCodedCurrencies.count, currencies.count)
        }
        catch {
            XCTFail("Check MockCurrenciesDataSource implementation. \(error.localizedDescription)")
        }
    }
}

// MARK: - Mocks

class MockCurrenciesDataSource: CurrenciesDataSource {
    let hardCodedCurrencies = ["EUR", "CHF", "USD", "GBP", "RUB", "JPY"]
    
    func getCurrencies() throws -> [String] {
        return hardCodedCurrencies
    }
}

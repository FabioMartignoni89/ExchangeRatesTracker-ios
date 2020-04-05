//
//  BaseExchangeRatesRepositoryTests.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import XCTest
import Combine

class BaseExchangeRatesRepositoryTests: XCTestCase {
    
    let mockUserDefaults = MockUserDefaults()
    let dataSource = MockCurrenciesDataSource()
    let persistenceService = MockExchangeRatesPersistenceService()
    var repo: ExchangeRatesRepository?
    let timeout = 5.0
    var subscribers = [AnyCancellable]()

    let EURCHF = CurrencyPairDTO(baseCurrency: "EUR", counterCurrency: "CHF")
    let CHFEUR = CurrencyPairDTO(baseCurrency: "CHF", counterCurrency: "EUR")

    override func setUp() {
        persistenceService.reset()
        repo = BaseExchangeRatesRepository(currenciesDataSource: dataSource,
                                           exchangeRatesPersistenceService: persistenceService)
    }
    
    override func tearDown() {
        for subscriber in subscribers {
            subscriber.cancel()
        }
    }
    
    
    func testZeroExchangesInitiallyReturned() {
        XCTAssertEqual(0 , try persistenceService.loadTrackedCurrencyPairs().count)
    }
    
    func testCanTrackExchangeRates() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        XCTAssertEqual(2 , try persistenceService.loadTrackedCurrencyPairs().count)
    }
    
    func testAvoidTrackingDuplications() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        XCTAssertEqual(2, try persistenceService.loadTrackedCurrencyPairs().count)
    }
    
    func testAvoidTrackingOfInvalidCurrencyPairs() {
        repo!.track(base: "CHF", counter: "CHF")
        repo!.track(base: "", counter: "CHF")
        XCTAssertEqual(0 , try persistenceService.loadTrackedCurrencyPairs().count)
    }
    
    func testCanUntrackCurrency() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")
        XCTAssertEqual(1, try persistenceService.loadTrackedCurrencyPairs().count)
    }
    
    func testUntrackEmptyListDoesNothing() {
        repo!.untrack(base: "CHF", counter: "EUR")
        XCTAssertEqual(0 , try persistenceService.loadTrackedCurrencyPairs().count)
    }
    
    func testUntrackMoreThanOneTimeDoesNothing() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")
        XCTAssertEqual(1, try persistenceService.loadTrackedCurrencyPairs().count)
    }
    
    func testCanGetCurrencies() {
        let currencies = repo!.getCurrencies()
        XCTAssertEqual(dataSource.hardCodedCurrencies.count, currencies.count)
    }
    
    func testCanGetCity() {
        let city = repo!.getRefCity(currency: "EUR")
        XCTAssertEqual("Bruxelles", city?.name)
    }
    
    func testCityIsNilIfCurrencyIsInvalid() {
        XCTAssertNil(repo!.getRefCity(currency: "ZZZ"))
    }
}

// MARK: - Mocks

class MockCurrenciesDataSource: ExchangeRatesDataSource {
    
    func getRefCity(currency: String) -> RefCity? {
        if currency == "EUR" {
            return RefCity(name: "Bruxelles", latitude: 1.0, longitude: 1.0)
        }
        else {
            return nil
        }
    }
    
    func fetchExchangeRates(currencyPairs: [String], onResult: @escaping (Result<[Double], Error>) -> ()) {
        var exchangeRates = [Double]()
        for _ in currencyPairs {
            exchangeRates.append(1.0)
        }
        onResult(.success(exchangeRates))
    }
    
    let hardCodedCurrencies = ["EUR", "CHF", "USD", "GBP", "RUB", "JPY"]
    
    func getCurrencies() throws -> [String] {
        return hardCodedCurrencies
    }
}

class MockExchangeRatesPersistenceService: ExchangeRatesPersistenceService {
    
    var pairs = [CurrencyPairDTO]()
    
    func saveTrackedCurrencyPairs(pairs: [CurrencyPairDTO]) throws {
        self.pairs = pairs
    }
    
    func loadTrackedCurrencyPairs() throws -> [CurrencyPairDTO] {
        return pairs
    }
    
    //MARK: - utils
    
    func reset() {
        pairs = [CurrencyPairDTO]()
    }
}

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
    let mockCurrenciesDataSource = MockCurrenciesDataSource()
    var repo: ExchangeRatesRepository?
    let timeout = 5.0
    var subscribers = [AnyCancellable]()

    let EURCHF = CurrencyPairDTO(baseCurrency: "EUR", counterCurrency: "CHF")
    let CHFEUR = CurrencyPairDTO(baseCurrency: "CHF", counterCurrency: "EUR")

    override func setUp() {
        repo = BaseExchangeRatesRepository(currenciesDataSource: mockCurrenciesDataSource,
                                           exchangeRatesPersistenceService: MockExchangeRatesPersistenceService())
    }
    
    override func tearDown() {
        for subscriber in subscribers {
            subscriber.cancel()
        }
    }
    
    /*
    func testZeroExchangesInitiallyReturned() {
        let promise = expectation(description: "No exchanges should be tracked initially.")

        subscribers.append(
            repo!.getExchangeRatesPublisher()
            .sink(receiveValue: { data in
                XCTAssertEqual(0 , data.count)
                promise.fulfill()
            })
        )
        
        wait(for: [promise], timeout: timeout)
    }
    
    func testCanTrackExchangeRates() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        
        let promise = expectation(description: "2 exchanges expected.")
        subscribers.append(
            repo!.getExchangeRatesPublisher()
            .sink(receiveValue: { data in
                
                XCTAssertEqual(2 , data.count)
                promise.fulfill()
        }))
        
        wait(for: [promise], timeout: timeout)
    }
    
    func testAvoidTrackingDuplications() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        
        let promise = expectation(description: "The same pair is being tracked multiple times.")

        subscribers.append(
            repo!.getExchangeRatesPublisher()
            .sink(receiveValue: { data in
                XCTAssertEqual(2 , data.count)
                promise.fulfill()
        }))
        
        wait(for: [promise], timeout: timeout)
    }
    
    func testAvoidTrackingOfInvalidCurrencyPairs() {
        repo!.track(base: "CHF", counter: "CHF")
        repo!.track(base: "", counter: "CHF")

        let promise = expectation(description: "Invalid pairs are not tracked.")

        subscribers.append(repo!.getExchangeRatesPublisher()
            .sink(receiveValue: { data in
                XCTAssertEqual(0 , data.count)
                promise.fulfill()
        }))
        
        wait(for: [promise], timeout: timeout)

    }
    
    func testCanUntrackCurrency() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")
        
        let promise = expectation(description: "the currency wil be untracked.")

        subscribers.append(repo!.getExchangeRatesPublisher()
            .sink(receiveValue: { data in
                XCTAssertEqual(1 , data.count)
                promise.fulfill()
        }))
                
        wait(for: [promise], timeout: timeout)
    }
    
    func testUntrackEmptyListDoesNothing() {
        repo!.untrack(base: "CHF", counter: "EUR")
        let promise = expectation(description: "nothing should happen.")

        subscribers.append(repo!.getExchangeRatesPublisher()
            .sink(receiveValue: { data in
                XCTAssertEqual(0 , data.count)
                promise.fulfill()
        }))
                
        wait(for: [promise], timeout: timeout)
    }
    
    func testUntrackMoreThanOneTimeDoesNothing() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")

        let promise = expectation(description: "the second untrack should have done nothing.")

        subscribers.append(repo!.getExchangeRatesPublisher()
            .sink(receiveValue: { data in
                XCTAssertEqual(1 , data.count)
                promise.fulfill()
        }))
        
        wait(for: [promise], timeout: timeout)
    }*/
    
    func testCanGetCurrencies() {
        let currencies = repo!.getCurrencies()
        XCTAssertEqual(mockCurrenciesDataSource.hardCodedCurrencies.count, currencies.count)
    }
}

// MARK: - Mocks

class MockCurrenciesDataSource: ExchangeRatesDataSource {
    
    func getRefCity(currency: String) -> RefCity? {
        return RefCity(name: "London", latitude: 1.0, longitude: 1.0)
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
    
    
}

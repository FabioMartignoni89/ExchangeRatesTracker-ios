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
    
    let EURCHF = CurrencyPairDTO(baseCurrency: "EUR", counterCurrency: "CHF")
    let CHFEUR = CurrencyPairDTO(baseCurrency: "CHF", counterCurrency: "EUR")

    override func setUp() {
        repo = BaseExchangeRatesRepository(currenciesDataSource: mockCurrenciesDataSource,
                                           exchangeRatesPersistenceService: MockExchangeRatesPersistenceService())
    }
    
    func testZeroExchangesInitiallyReturned() {
        let promise = expectation(description: "No exchanges should be tracked initially.")

        repo!.getExchangeRates() { result in
            switch result {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                    break

                case let .success(data):
                    XCTAssertEqual(0 , data.count)
                    promise.fulfill()
                    break
            }
        }
        
        wait(for: [promise], timeout: 1)
    }
    
    func testCanTrackExchangeRates() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        
        let promise = expectation(description: "2 exchanges expected.")

        repo!.getExchangeRates() { result in
            switch result {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                    break

                case let .success(data):
                    XCTAssertEqual(2 , data.count)
                    promise.fulfill()
                    break
            }
        }
        
        wait(for: [promise], timeout: 1)
    }
    
    func testAvoidTrackingDuplications() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        
        let promise = expectation(description: "The same pair is being tracked multiple times.")

        repo!.getExchangeRates() { result in
            switch result {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                    break

                case let .success(data):
                    XCTAssertEqual(2 , data.count)
                    promise.fulfill()
                    break
            }
        }
        
        wait(for: [promise], timeout: 1)
    }
    
    func testAvoidTrackingOfInvalidCurrencyPairs() {
        repo!.track(base: "CHF", counter: "CHF")
        repo!.track(base: "", counter: "CHF")

        let promise = expectation(description: "Invalid pairs are not tracked.")

        repo!.getExchangeRates() { result in
            switch result {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                    break

                case let .success(data):
                    XCTAssertEqual(0, data.count)
                    promise.fulfill()
                    break
            }
        }
        
        wait(for: [promise], timeout: 1)

    }
    
    func testCanUntrackCurrency() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")
        
        let promise = expectation(description: "the currency wil be untracked.")

        repo!.getExchangeRates() { result in
            switch result {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                    break

                case let .success(data):
                    XCTAssertEqual(1, data.count)
                    promise.fulfill()
                    break
            }
        }
        
        wait(for: [promise], timeout: 1)
    }
    
    func testUntrackEmptyListDoesNothing() {
        repo!.untrack(base: "CHF", counter: "EUR")
        let promise = expectation(description: "nothing should happen.")

        repo!.getExchangeRates() { result in
            switch result {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                    break

                case let .success(data):
                    XCTAssertEqual(0, data.count)
                    promise.fulfill()
                    break
            }
        }
        
        wait(for: [promise], timeout: 1)
    }
    
    func testUntrackMoreThanOneTimeDoesNothing() {
        repo!.track(base: "EUR", counter: "CHF")
        repo!.track(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")
        repo!.untrack(base: "CHF", counter: "EUR")

        let promise = expectation(description: "the second untrack should have done nothing.")

        repo!.getExchangeRates() { result in
            switch result {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                    break

                case let .success(data):
                    XCTAssertEqual(1, data.count)
                    promise.fulfill()
                    break
            }
        }
        
        wait(for: [promise], timeout: 1)
    }
    
    func testCanGetCurrencies() {
        let currencies = repo!.getCurrencies()
        XCTAssertEqual(mockCurrenciesDataSource.hardCodedCurrencies.count, currencies.count)
    }
}

// MARK: - Mocks

class MockCurrenciesDataSource: ExchangeRatesDataSource {
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

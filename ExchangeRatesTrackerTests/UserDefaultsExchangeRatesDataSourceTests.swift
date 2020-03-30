//
//  UserDefaultsExchangeRatesDataSourceTests.swift
//  ExchangeRatesTrackerTests
//
//  Created by Fabio Martignoni on 30/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import XCTest

class UserDefaultsExchangeRatesDataSourceTests: XCTestCase {
    
    private var userDefaultsMock = MockUserDefaults()
    private var dataSource: ExchangeRatesPersistenceService?
    
    override func setUp() {
        userDefaultsMock.reset()
        dataSource = UserDefaultsExchangeRatesPersistenceService(userDefaults: userDefaultsMock)
    }
    
    func testLoadExchangesInitiallyEmpty() {
        XCTAssertEqual(0, try? dataSource!.loadTrackedCurrencyPairs().count)
    }
    
    func testCanSaveExchanges() {
        do {
            try dataSource!.saveTrackedCurrencyPairs(pairs: prepareTestPairs1())
            let pairs = try dataSource!.loadTrackedCurrencyPairs()
            XCTAssertEqual(prepareTestPairs1(), pairs)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testCanOverrideExchanges() {
        do {
            try dataSource!.saveTrackedCurrencyPairs(pairs: prepareTestPairs1())
            try dataSource!.saveTrackedCurrencyPairs(pairs: prepareTestPairs2())
            let pairs = try dataSource!.loadTrackedCurrencyPairs()
            XCTAssertEqual(prepareTestPairs2(), pairs)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    // MARK: Utils
    
    private func prepareTestPairs1() -> [CurrencyPair] {
        return [CurrencyPair(baseCurrency: "A", counterCurrency: "B"),
                CurrencyPair(baseCurrency: "F", counterCurrency: "B"),
                CurrencyPair(baseCurrency: "A", counterCurrency: "C")]
    }
    
    private func prepareTestPairs2() -> [CurrencyPair] {
        return [CurrencyPair(baseCurrency: "C", counterCurrency: "B"),
                CurrencyPair(baseCurrency: "F", counterCurrency: "B"),
                CurrencyPair(baseCurrency: "A", counterCurrency: "C")]
    }
}

// MARK: - Mocks

class MockUserDefaults: UserDefaults {
  
    private var dict = [String: Any?]()
    
    func reset() {
        dict = [String: Any?]()
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        dict[defaultName] = value
    }
        
    override func value(forKey key: String) -> Any? {
        dict[key] ?? nil
    }
}

extension Array where Element: Equatable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count
    }
}

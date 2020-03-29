//
//  BundleCurrenciesDataSourceTest.swift
//  ExchangeRatesTrackerTests
//
//  Created by Fabio Martignoni on 27/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import XCTest

class BundleCurrenciesDataSourceTest: XCTestCase {
    
    func testCanGetCurrencies() {
        do {
            let dataSource: CurrenciesDataSource = BundleCurrenciesDataSource(fileName: "validCurrencies-test")
            
            let currencies = try dataSource.getCurrencies()
            XCTAssertEqual(currencies.count, 6, "6 currencies expected.")
        }
        catch {
            XCTFail("Can't get currencies: \(error)")
        }
    }
    
    func testThrowsIfJSONIsInvalid() {
        XCTAssertThrowsError(try BundleCurrenciesDataSource(fileName: "invalidCurrencies-test").getCurrencies())
    }
    
    func testThrowsIfJSONFileDoNotExists() {
        XCTAssertThrowsError(try BundleCurrenciesDataSource(fileName: "wrongFileName-test").getCurrencies())
    }
}

//
//  JSONCurrenciesDataSourceTest.swift
//  ExchangeRatesTrackerTests
//
//  Created by Fabio Martignoni on 27/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import XCTest

class BundleJSONCurrenciesDataSourceTest: XCTestCase {
    
    private let TEST_JSON = """
    {
        "world_currencies": [
            {"currency": "GBP", "city": {"name": "London", "lat": 51.509865, "lon": -0.118092}},
            {"currency": "EUR", "city": {"name": "Bruxelles", "lat": 50.850340, "lon": 4.351710}},
            {"currency": "USD", "city": {"name": "Washington D.C.", "lat": 38.89511, "lon": -77.03637}},
            {"currency": "RUB", "city": {"name": "Moscow", "lat": 55.751244, "lon": 37.618423}},
            {"currency": "CHF", "city": {"name": "Bern", "lat": 46.94809, "lon": 7.44744}},
            {"currency": "JPY", "city": {"name": "Tokyo", "lat": 35.652832, "lon": 139.839478}}
        ]
    }
"""
    
    override func setUp() {

    }
    
    func testCanGetCurrencies() {
        do {
            let dataSource: CurrenciesDataSource = JSONCurrenciesDataSource(json: TEST_JSON)
            
            let currencies = try dataSource.getCurrencies()
            XCTAssertEqual(currencies.count, 6, "6 currencies expected.")
        }
        catch {
            XCTFail("Can't get currencies: \(error)")
        }
    }
    
    func testGetCurrencyThrowsIfJSONIsInvalid() {
        XCTAssertThrowsError(try JSONCurrenciesDataSource(json: "").getCurrencies())
    }
}

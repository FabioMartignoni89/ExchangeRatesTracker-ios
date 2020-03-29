//
//  ExchangeRatesRouter.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation


protocol ExchangeRatesRoutingLogic {
 
    func newExchangeRate() -> NewExchangeRateView
}

class ExchangeRatesRouter: ExchangeRatesRoutingLogic {
    
    func newExchangeRate() -> NewExchangeRateView {
        return NewExchangeRateBuilder.build()
    }
    
        
}

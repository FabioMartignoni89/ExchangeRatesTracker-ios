//
//  ExchangeRow.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import SwiftUI

struct ExchangeRow: View {
    
    @ObservedObject var rowViewModel: ExchangeRateDisplayModel
    
    var body: some View {
        HStack {
            Text("\(rowViewModel.baseCurrency)\\\(rowViewModel.counterCurrency)")
            Text("=")
            Text("\(rowViewModel.exchangeValue)").bold()
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ExchangeRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExchangeRow(rowViewModel: ExchangeRateDisplayModel(baseCurrency: "EUR",
                                                                    counterCurrency: "USD",
                                                                     exchangeValue: "1.1232"))
                .previewLayout(.fixed(width: 200, height: 70))
            ExchangeRow(rowViewModel: ExchangeRateDisplayModel(baseCurrency: "EUR",
                                                                    counterCurrency: "USD",
                                                                    exchangeValue: "1.1232"))
                .previewLayout(.fixed(width: 500, height: 70))
        }
    }
}

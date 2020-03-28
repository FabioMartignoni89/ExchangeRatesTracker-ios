//
//  ExchangeRow.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import SwiftUI
var test = [ExchangeRowViewModel]()

struct ExchangeRow: View {
    
    var viewModel: ExchangeRowViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Text("\(viewModel.currencyRatioText)")
            Text("=")
            Text("\(viewModel.exchangeValue)").bold()
            Spacer()
        }
    }
}

struct ExchangeRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExchangeRow(viewModel: ExchangeRowViewModel(id: "EURUSD", currencyRatioText: "EUR/USD", exchangeValue: 1.1232))
                .previewLayout(.fixed(width: 200, height: 70))
            ExchangeRow(viewModel: ExchangeRowViewModel(id: "EURUSD", currencyRatioText: "EUR/USD", exchangeValue: 1.1232))
                .previewLayout(.fixed(width: 500, height: 70))
        }
    }
}

struct ExchangeRowViewModel: Identifiable {
    var id: String
    let currencyRatioText: String
    let exchangeValue: Double
}

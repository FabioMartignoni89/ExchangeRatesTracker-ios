//
//  ExchangeRow.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 28/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import SwiftUI
var test = [ExchangeRowPresentationModel]()

struct ExchangeRow: View {
    
    var presentationModel: ExchangeRowPresentationModel
    
    var body: some View {
        HStack {
            Text("\(presentationModel.currencyRatioText)")
            Text("=")
            Text("\(presentationModel.exchangeValue)").bold()
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ExchangeRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExchangeRow(presentationModel: ExchangeRowPresentationModel(currencyRatioText: "EUR/USD", exchangeValue: "1.1232"))
                .previewLayout(.fixed(width: 200, height: 70))
            ExchangeRow(presentationModel: ExchangeRowPresentationModel(currencyRatioText: "EUR/USD", exchangeValue: "1.1232"))
                .previewLayout(.fixed(width: 500, height: 70))
        }
    }
}

struct ExchangeRowPresentationModel: Identifiable {
    var id = UUID()
    let currencyRatioText: String
    let exchangeValue: String
}

//
//  ExchangesView.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 27/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import SwiftUI

public struct ExchangesView: View {
    
    var exchanges = [ExchangeRowViewModel](repeating: ExchangeRowViewModel(id: "EURUSD", currencyRatioText: "EUR/USD", exchangeValue: 1.1232), count: 30)
    
    public var body: some View {
        NavigationView() {
            List(exchanges) { exchange in
                //NavigationLink(destination: ...DetailView()) {
                    ExchangeRow(viewModel: exchange)
                //}
            }
            .navigationBarTitle("Exchange rates")
            .navigationBarItems(trailing: Button(action: {
                //TODO: implement add exchange action
            }) {
                Text("Add")
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForEach(["iPhone XS Max", "iPad Pro (9.7-inch)"], id: \.self) { deviceName in
            ExchangesView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

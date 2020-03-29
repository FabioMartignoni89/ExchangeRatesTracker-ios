//
//  ExchangeRatesView.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 27/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import SwiftUI
import Combine

public struct ExchangeRatesView: View {

    @ObservedObject var viewModel: BaseExchangeRatesViewModel
    
    init(viewModel: BaseExchangeRatesViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView() {
            List(viewModel.exchangeRates.map({ (ExchangeRate) -> ExchangeRowPresentationModel in
                convert(exchange: ExchangeRate)
            })) { exchange in
                //NavigationLink(destination: ...DetailView()) {
                ExchangeRow(presentationModel: exchange)
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
    
    private func convert(exchange: ExchangeRate) -> ExchangeRowPresentationModel {
        let pair = exchange.currencyPair
        let ratioText = "\(pair.baseCurrency)/\(pair.counterCurrency)"
        let exchangeText = exchange.exchangeRate != nil ? "\(exchange.exchangeRate!)" : "-"
        return ExchangeRowPresentationModel(currencyRatioText: ratioText, exchangeValue: exchangeText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForEach(["iPhone XS Max", "iPad Pro (9.7-inch)"], id: \.self) { deviceName in
            ExchangeRatesView(viewModel: getPreviewViewModel())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
    
    private static func getPreviewViewModel() -> BaseExchangeRatesViewModel {
        let repository = MockExchangeRatesRepository()
        let viewModel = BaseExchangeRatesViewModel(repository: repository)
        return viewModel
    }
}

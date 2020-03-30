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
    let viewProvider: ViewProvider
    @State private var isNexExchangeRateViewPresented = false

    init(viewModel: BaseExchangeRatesViewModel, viewProvider: ViewProvider) {
        self.viewModel = viewModel
        self.viewProvider = viewProvider
    }
    
    public var body: some View {
        NavigationView() {
            List() {
                Section() {
                    ForEach(viewModel.exchangeRates.map({ (ExchangeRate) -> ExchangeRowPresentationModel in
                        convert(exchange: ExchangeRate)
                    })) { exchange in
                        ExchangeRow(presentationModel: exchange)
                    }
                    .onDelete(perform: delete)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Exchange rates")
            .navigationBarItems(trailing: addButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $isNexExchangeRateViewPresented, onDismiss: {
            self.viewModel.fetchExchanges()
        }) {
            self.viewProvider.provideNewExchangeRate()
        }
        .onAppear {
            //stop ask 4 updates..
        }
    }
    
    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else {
            return
        }
        let exchange = self.viewModel.exchangeRates.remove(at: index)
        self.viewModel.untrackExchangeRate(exchange: exchange)
    }
    
    // MARK: - sub views
    
    private var addButton: some View {
        Button(action: {
           self.isNexExchangeRateViewPresented.toggle()
        }) {
            Text("Add")
            //Image(systemName: "plus")
        }
    }
    
    // MARK: - utils
    
    private func convert(exchange: ExchangeRate) -> ExchangeRowPresentationModel {
        let ratioText = "\(exchange.baseCurrency)/\(exchange.counterCurrency)"
        let exchangeText = exchange.exchangeRate != nil ? "\(exchange.exchangeRate!)" : "-"
        return ExchangeRowPresentationModel(currencyRatioText: ratioText, exchangeValue: exchangeText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone XS Max", "iPad Pro (9.7-inch)"], id: \.self) { deviceName in
            ExchangeRatesView(viewModel: getPreviewViewModel(), viewProvider: BaseViewProvider())
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

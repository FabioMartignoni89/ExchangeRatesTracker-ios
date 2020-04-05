//
//  ExchangeRatesView.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 27/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import SwiftUI
import Combine
import MapKit

public struct ExchangeRatesView: View {
    @ObservedObject var viewModel: BaseExchangeRatesViewModel
    let viewProvider: ViewProvider
    let m = ExchangeRateMapView(annotation: RefCityAnnotation(city: "London",
    exchangeRate: "EUR/CHF = 1.1264",
    coordinate: CLLocationCoordinate2D(latitude: 34.011286,
                                       longitude: -116.166868)))
    @State private var isNewExchangeRateViewPresented = false

    init(viewModel: BaseExchangeRatesViewModel, viewProvider: ViewProvider) {
        self.viewModel = viewModel
        self.viewProvider = viewProvider
    }
    
    public var body: some View {
        NavigationView() {
            List() {
                Section() {
                    ForEach(viewModel.exchangeRates) { exchange in
                        NavigationLink(destination: self.m) {
                            ExchangeRow(rowViewModel: exchange)
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(NSLocalizedString("exchange_rates", comment: ""))
            .navigationBarItems(trailing: addButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $isNewExchangeRateViewPresented, onDismiss: {

        }) {
            self.viewProvider.provideNewExchangeRate()
        }
    }
    
    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else {
            return
        }
        self.viewModel.untrackExchangeRate(index: index)
    }
    
    // MARK: - sub views
    
    private var addButton: some View {
        Button(action: {
           self.isNewExchangeRateViewPresented.toggle()
        }) {
            Text(NSLocalizedString("add_button", comment: ""))
        }
    }
    
    // MARK: - utils
    
    private func convert(exchange: ExchangeRate) -> ExchangeRateDisplayModel {
        let exchangeText = exchange.exchangeRate != nil ? "\(exchange.exchangeRate!)" : "-"
        return ExchangeRateDisplayModel(baseCurrency: exchange.baseCurrency,
                                        counterCurrency: exchange.counterCurrency,
                                        exchangeValue: exchangeText)
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

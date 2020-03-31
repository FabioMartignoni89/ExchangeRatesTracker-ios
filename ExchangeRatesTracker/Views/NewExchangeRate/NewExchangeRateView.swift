//
//  NewExchangeRateView.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import SwiftUI

struct NewExchangeRateView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: BaseNewExchangeRateViewModel
    @State private var selectedBaseCurrency = 0
    @State private var selectedCounterCurrency = 0

    init(viewModel: BaseNewExchangeRateViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(NSLocalizedString("select_currencies", comment: ""))
                .font(.title)
            self.currencyPickersView
            HStack {
                Spacer()
                self.confirmButton
            }
        }
        .padding(.all, 20.0)
    }
    
    // MARK: - sub views
    
    private var currencyPickersView: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Spacer()
                VStack {
                    Text(NSLocalizedString("base_currency", comment: ""))
                    Picker(selection: self.$selectedBaseCurrency, label: Text("")) {
                        ForEach(0 ..< self.viewModel.currencies.count) {
                            Text(self.viewModel.currencies[$0])
                        }
                    }
                    .frame(maxWidth: geometry.size.width / 2.5)
                    .clipped()
                    .labelsHidden()
                }
                Spacer()
                VStack {
                    Text(NSLocalizedString("counter_currency", comment: ""))
                    Picker(selection: self.$selectedCounterCurrency, label: Text("")) {
                        ForEach(0 ..< self.viewModel.currencies.count) {
                            Text(self.viewModel.currencies[$0])
                        }
                    }
                    .frame(maxWidth: geometry.size.width / 2.5)
                    .clipped()
                    .labelsHidden()
                }
                Spacer()
            }
        }
    }
    
    private var confirmButton: some View {
        Button(action: {
            let base = self.viewModel.currencies[self.selectedBaseCurrency]
            let counter = self.viewModel.currencies[self.selectedCounterCurrency]
            self.viewModel.trackNewExchangeRate(baseCurrency: base, counterCurrency: counter)
            
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text(NSLocalizedString("confirm_button", comment: ""))
        }
    }
}

struct NewExchangeRateView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone XS Max", "iPad Pro (9.7-inch)"], id: \.self) { deviceName in
            NewExchangeRateView(viewModel: getPreviewViewModel())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
    
    private static func getPreviewViewModel() -> BaseNewExchangeRateViewModel {
        let repository = MockExchangeRatesRepository()
        let viewModel = BaseNewExchangeRateViewModel(repository: repository)
        return viewModel
    }
}

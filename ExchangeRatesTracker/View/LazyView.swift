//
//  LazyView.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 05/04/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct LazyView_Previews: PreviewProvider {
    static var previews: some View {
        LazyView(Text("Hello lazy view."))
    }
}

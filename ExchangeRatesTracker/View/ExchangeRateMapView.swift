//
//  ExchangeRateMapView.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 05/04/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import SwiftUI
import MapKit

struct ExchangeRateMapView: UIViewRepresentable {
    @ObservedObject var viewModel: BaseExchangeRateMapViewModel
    
    let mapDelegate = ExchangeRateMapDelegate()
    
    init(viewModel: BaseExchangeRateMapViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = viewModel.mapAnnotation {
            
            let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            uiView.setRegion(region, animated: true)
            
            uiView.addAnnotation(annotation)
            uiView.delegate = mapDelegate
        }
    }
}

struct ExchangeRateMapView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeRateMapView(viewModel: getPreviewViewModel())
    }
    
    private static func getPreviewViewModel() -> BaseExchangeRateMapViewModel {
        let repository = MockExchangeRatesRepository()
        let viewModel = BaseExchangeRateMapViewModel(repository: repository,
                                                     baseCurrency: "EUR",
                                                     counterCurrency: "CHF")
        return viewModel
    }
}

class ExchangeRateMapDelegate: NSObject, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      guard let annotation = annotation as? RefCityAnnotation else {
        return nil
      }
      let identifier = "ref_city"
      var view: MKMarkerAnnotationView

      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
        dequeuedView.annotation = annotation
        view = dequeuedView
      }
      else {
        view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .system)
      }
      return view
    }
}

class RefCityAnnotation: NSObject, MKAnnotation, ObservableObject {
  let title: String?
  var exchangeRate: String?
  let coordinate: CLLocationCoordinate2D

  init(
    city: String,
    exchangeRate: String,
    latitude: Double,
    longitude: Double
  ) {
    self.title = city
    self.exchangeRate = exchangeRate
    self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

    super.init()
  }

  var subtitle: String? {
    return exchangeRate
  }
}

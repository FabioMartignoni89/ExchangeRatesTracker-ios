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
    let annotation: RefCityAnnotation
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        uiView.setRegion(region, animated: true)
        uiView.addAnnotation(annotation)
        uiView.delegate = annotation
    }
}

struct ExchangeRateMapView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeRateMapView(annotation:
            RefCityAnnotation(city: "London",
                              exchangeRate: "EUR/CHF = 1.1264",
                    coordinate: CLLocationCoordinate2D(latitude: 34.011286,
                                                       longitude: -116.166868))
        )
    }
}

class RefCityAnnotation: NSObject, MKAnnotation, MKMapViewDelegate {
  let title: String?
  let exchangeRate: String?
  let coordinate: CLLocationCoordinate2D

  init(
    city: String?,
    exchangeRate: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = city
    self.exchangeRate = exchangeRate
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return exchangeRate
  }
    
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

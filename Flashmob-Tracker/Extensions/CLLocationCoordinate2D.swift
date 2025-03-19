//
//  CLLocationCoordinate2D.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 03.03.25.
//


import MapKit


extension CLLocationCoordinate2D {
    
    static private var _home: CLLocationCoordinate2D?
    
    static var home: CLLocationCoordinate2D {
        get {
            
            Self._home ?? CLLocationCoordinate2D(
                latitude: 52.501497, longitude: 13.520374)
        }
        set { Self._home = newValue }
    }
}

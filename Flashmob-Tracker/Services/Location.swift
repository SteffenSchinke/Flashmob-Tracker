//
//  Location.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 23.02.25.
//


import SwiftUI
import MapKit
import CoreLocation


@Observable
final class Location: NSObject, CLLocationManagerDelegate {
    
    private var manager = CLLocationManager()
    
    var userLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
    }
    
    func requestPermission() { manager.requestWhenInUseAuthorization() }
    
    func startUpdatingLocation() { manager.startUpdatingLocation() }
    
    func stopUpdatingLocation() { manager.stopUpdatingLocation() }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations.last
    }
}

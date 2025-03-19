//
//  MapVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 03.03.25.
//


import SwiftUI
import Observation
import CoreLocation
import UIKit
import MapKit

@Observable
final class MapVM: ViewModelBaseClass {
    
    var isShowLookAroundScene = false
    var isUpdateMapComponentsInProgress: Bool = false
    var isPickupMapMode: Bool = false
    var txtSearch: String = ""

    var annotations: [any FlashmobAnnotation] = []
    var cameraPosition: MapCameraPosition
    var lookAroundScene: MKLookAroundScene?
    
    
    override init() {
        
        let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D.home,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000)
        
        self.cameraPosition = .region(region)
        
        super.init()
        self.isWorking = false
    }

    func setMapLocationBySearch() {
        
        Task {

            await self.setIsWorking(true)
            
            guard let placemark = try? await CLGeocoder().geocodeAddressString(self.txtSearch).first,
                  let location = placemark.location else {
                
                self.setError("error_map_search")
                return
            }
            
            let newLocation = FlashmobLocation(
                street: "\(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "")",
                zipCode: placemark.postalCode ?? "",
                city: placemark.locality ?? "",
                country: placemark.country ?? "",
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
            
            self.annotations.append(newLocation)
            self.setCoord(location.coordinate)
            
            await self.setIsWorking(false)
        }
    }
    
    func insertProfileLocation( _ appUser: AppUser) {
        
        Task {
            
            await self.setIsWorking(true)
            
            self.annotations.append(appUser)
            self.setCoord(appUser.location)
            
            await self.setIsWorking(false)
        }
    }
    
    func deleteProfileLocation( _ appUser: AppUser) {
        
        Task {
            
            await self.setIsWorking(true)
            
            self.annotations.removeAll { $0.id == appUser.id }
            self.setMapRegion()
            
            await self.setIsWorking(false)
        }
    }
    
    func insertEventLocation( _ event: Event) {
        
        Task {
            
            await self.setIsWorking(false)
            
            if !self.annotations.contains(
                where: { $0.id == event.id }) {
                
                self.annotations.append(event)
            }
            
            self.setCoord(event.location)
            
            await self.setIsWorking(false)
        }
    }

    func setEventLocations(_ events: [Event]) {
        
        Task {
         
            await self.setIsWorking(true)
            
            self.annotations = events
            self.setMapRegion()
            
            await self.setIsWorking(false)
        }
    }
    
    func setSingleMapMarker(_ coords: CLLocationCoordinate2D) async -> FlashmobLocation? {
        
        let location = CLLocation(latitude: coords.latitude,
                                  longitude: coords.longitude)
        guard let placemark = try? await
                CLGeocoder().reverseGeocodeLocation(location).first else {
            
            self.setError("err_map_calc")
            return nil
        }
        
        let newLocation = FlashmobLocation(
            street: "\(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "")",
            zipCode: placemark.postalCode ?? "",
            city: placemark.locality ?? "",
            country: placemark.country ?? "",
            latitude: coords.latitude,
            longitude: coords.longitude)
        
        self.annotations = []
        self.annotations.append(newLocation)
        self.setLookAroundScene(coords)
        
        return newLocation
    }

    func setOrganizers( _ organizers: [Organizer]) {
        
        Task {
            
            await self.setIsWorking(true)
            
            self.annotations = organizers
            self.setMapRegion()
            
            await self.setIsWorking(false)
        }
    }
    
    func setMapRegion() {
        
        if self.annotations.count == 0  {
        
            setError("err_map_event_zoom")
            return
        }
        
        if self.annotations.count == 1 {
            
            self.setCoord(self.annotations[0].coord2D)
            return
        }

        let coords = self.annotations.compactMap {
                anno -> CLLocationCoordinate2D? in anno.coord2D }
        let minLat = coords.map { $0.latitude }.min()!
        let maxLat = coords.map { $0.latitude }.max()!
        let minLon = coords.map { $0.longitude }.min()!
        let maxLon = coords.map { $0.longitude }.max()!
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let center = CLLocationCoordinate2D(latitude: centerLat,
                                            longitude: centerLon)
        
        let spanLat = (maxLat - minLat) * 1.3  // 30% Puffer
        let spanLon = (maxLon - minLon) * 1.3  // 30% Puffer
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(
                                            latitudeDelta: spanLat,
                                            longitudeDelta: spanLon))

        self.cameraPosition = .region(region)
    }
    
    private func setCoord( _ location: FlashmobLocation? ) {
        
        guard let loc = location else { return }
        
        self.setCoord(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
    }
    
    private func setCoord( _ coord: CLLocationCoordinate2D ) {
        
        self.setCoord(coord.latitude, coord.longitude)
    }
    
    private func setCoord( _ lat: Double, _ lon: Double ) {
        
        let coord = CLLocationCoordinate2D(
                        latitude: lat,
                        longitude: lon)
        let region = MKCoordinateRegion(center: coord,
                        latitudinalMeters: 1000,
                        longitudinalMeters: 1000)
        
        Task { @MainActor in
            
            self.cameraPosition = .region(region)
            self.setLookAroundScene(coord)
        }
    }
    
    private func setLookAroundScene(_ coords: CLLocationCoordinate2D) {
        
        Task {
            
            do {
                
                self.lookAroundScene =
                        try await MKLookAroundSceneRequest(
                                    coordinate: coords).scene
            } catch {
                
                print(error.localizedDescription)
            }
        }
    }
}

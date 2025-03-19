//
//  FlashmobAnnotation.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 14.03.25.
//


import MapKit
import SwiftUI

protocol FlashmobAnnotation: Codable, Identifiable, CustomStringConvertible {
    
    var id: String { get }
    var isOnlyMarker: Bool { get set }
    var coord2D: CLLocationCoordinate2D { get }
}

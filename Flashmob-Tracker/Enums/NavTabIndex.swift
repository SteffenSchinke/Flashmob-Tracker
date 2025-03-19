//
//  NavViewIndex.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on12.02.25.
//


enum NavTabIndex: Int {
    
    case dashboard
    case map
    case friends
    case detail
    case create
    case profile
    case agb
    case dsgvo
    case filter
    case appSetting
    
    var index: Int { return rawValue }
}

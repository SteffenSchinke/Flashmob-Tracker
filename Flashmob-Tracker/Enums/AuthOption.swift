//
//  LoginOption.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


enum AuthOption: Int {
    
    case custom
    case apple
    case google
    case facebook
    case twitter
    case instagram
    
    var index: Int { rawValue }
}

//
//  NavLinkDestInfos.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 15.03.25.
//


import SwiftUI


struct NavLinkDash: Hashable, Identifiable {
    
    var id: String = UUID().uuidString
    var navObjectId: String
    var tabIndex: NavTabIndex
    var nameSpace: Namespace.ID
}

struct NavLinkSetting: Hashable, Identifiable {
    
    var id: String = UUID().uuidString
    var tabIndex: NavTabIndex
    var nameSpace: Namespace.ID
}

struct NavLinkMap: Hashable, Identifiable {
    
    var id: String = UUID().uuidString
    var annoId: String
    var annoType: Any.Type
    var nameSpace: Namespace.ID
    
    // while annoType protocol type, explicete implements
    static func == (lhs: NavLinkMap, rhs: NavLinkMap) -> Bool {
        return lhs.id == rhs.id
    }
    
    // while annoType protocol type, explicete implements
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct NavLinkProfile: Hashable, Identifiable {
    
    var id: String = UUID().uuidString
    var profileId: String
    var nameSpace: Namespace.ID
}

struct NavLinkPDF: Hashable, Identifiable {
    
    var id: String = UUID().uuidString
    var url: URL
    var nameSpace: Namespace.ID
}

//
//  SFIcon.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 24.02.25.
//


enum SFIcon: String {
    
    case zoomIn = "arrow.down.backward.and.arrow.up.forward.rectangle"
    case zoomOut = "arrow.down.right.and.arrow.up.left.rectangle"
    case search = "magnifyingglass"
    case back = "chevron.backward"
    case dashboard = "list.dash.header.rectangle"
    case map = "map"
    case mappin = "mappin"
    case mappin_off = "mappin.slash"
    case mappin_map = "mappin.and.ellipse"
    case persons = "person.2.fill"
    case setting = "gear"
    case globe = "globe"
    case widget = "widget.small"
    case info = "info.square"
    case signOut = "door.left.hand.open"
    case menu = "ellipsis.circle"
    case add = "plus.rectangle"
    case eye = "eye"
    case filter = "slider.vertical.3"
    case text = "text.bubble"
    case cal = "calendar"
    case team = "theatermasks"
    case flame = "flame"
    case doc = "doc"
    case person = "person"
    case person_auth = "person.badge.shield.checkmark"
    case heart = "heart"
    case heart_fill = "heart.fill"
    
    var key: String { self.rawValue }
}

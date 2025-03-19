//
//  AppStorageKey.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


enum AppStorageKey: String, CodingKey {
    
    case isDarkMode
    case isAnimeBackground
    case selectedNavTabIndex
    case selectedLanguage
    case isNoticeAllowed
    case isNoticeNewEventsAllowed
    case isNoticeNewMessageAllowed
    case isNoticeMemoriesAllowed
    case isAskedForPermission
    case isAuthorized
    case isScheduleRunning
    
    var key: String { self.rawValue }
}

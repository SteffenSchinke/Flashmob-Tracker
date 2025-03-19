//
//  AppSettingsVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI
import Observation


@Observable
final class AppSettingsVM: ViewModelBaseClass {
    
    var isDarkMode: Bool {
        didSet { UserDefaults.standard.set(
                    self.isDarkMode,
                    forKey: AppStorageKey.isDarkMode.key) }
    }
    
    var isAnimeBackground: Bool {
        didSet { UserDefaults.standard.set(
                    self.isAnimeBackground,
                    forKey: AppStorageKey.isAnimeBackground.key) }
    }
    
    var selectedNavTabIndex: Int {
        didSet { UserDefaults.standard.set(
                    self.selectedNavTabIndex,
                    forKey: AppStorageKey.selectedNavTabIndex.key) }
    }
    
    var isNoticeAllowed: Bool {
        didSet { UserDefaults.standard.set(
                    self.isNoticeAllowed,
                    forKey: AppStorageKey.isNoticeAllowed.key)
            
            if !self.isNoticeAllowed {
                
                self.isNoticeNewEventsAllowed = false
                self.isNoticeNewMessageAllowed = false
                self.isNoticeMemoriesAllowed = false
            }
        }
    }
    
    var isNoticeNewEventsAllowed: Bool {
        didSet { UserDefaults.standard.set(
                    self.isNoticeNewEventsAllowed,
                    forKey: AppStorageKey.isNoticeNewEventsAllowed.key) }
    }
    
    var isNoticeNewMessageAllowed: Bool {
        didSet { UserDefaults.standard.set(
                    self.isNoticeNewMessageAllowed,
                    forKey: AppStorageKey.isNoticeNewMessageAllowed.key) }
    }
    
    var isNoticeMemoriesAllowed: Bool {
        didSet { UserDefaults.standard.set(
                    self.isNoticeMemoriesAllowed,
                    forKey: AppStorageKey.isNoticeMemoriesAllowed.key) }
    }

    override init() {
        
        self.isDarkMode = UserDefaults.standard.bool(forKey: AppStorageKey.isDarkMode.key)
        self.isAnimeBackground = UserDefaults.standard.bool(forKey: AppStorageKey.isAnimeBackground.key)
        self.selectedNavTabIndex = UserDefaults.standard.integer(forKey: AppStorageKey.selectedNavTabIndex.key)
        self.isNoticeAllowed = UserDefaults.standard.bool(forKey: AppStorageKey.isNoticeAllowed.key)
        self.isNoticeNewEventsAllowed = UserDefaults.standard.bool(forKey: AppStorageKey.isNoticeNewEventsAllowed.key)
        self.isNoticeNewMessageAllowed = UserDefaults.standard.bool(forKey: AppStorageKey.isNoticeNewMessageAllowed.key)
        self.isNoticeMemoriesAllowed = UserDefaults.standard.bool(forKey: AppStorageKey.isNoticeMemoriesAllowed.key)
        
        super.init()
    }
}

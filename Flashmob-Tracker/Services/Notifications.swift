//
//  Notifications.swift
//  DogLike
//
//  Created by Steffen Steffen on 12.02.25.
//


import Observation
import UserNotifications


@MainActor
@Observable
final class Notifications {
    
    /// Singleton pattern
    static let shared = Notifications()
    private init() {
        
        self.isAskedForPermission =
                UserDefaults.standard.bool(
                        forKey: AppStorageKey.isAskedForPermission.key)
        self.isAuthorized =
                UserDefaults.standard.bool(
                        forKey: AppStorageKey.isAuthorized.key)
        self.isScheduleRunning =
                UserDefaults.standard.bool(
                        forKey: AppStorageKey.isScheduleRunning.key)
        
        if self.isAskedForPermission {
            
            Task {
                
                do {
                    
                    let center = UNUserNotificationCenter.current()
                    self.isAuthorized = try await center.requestAuthorization(
                                                    options: [.sound, .alert, .badge])
                } catch {}
            }
        }
    }
    
    var errorMessage: String?
    var isAskedForPermission: Bool {
        didSet {
            UserDefaults.standard.set(
                self.isAskedForPermission,
                forKey: AppStorageKey.isAskedForPermission.key) }
    }
    var isAuthorized: Bool {
        didSet {
            UserDefaults.standard.set(
                self.isAuthorized,
                forKey: AppStorageKey.isAuthorized.key) }
    }
    var isScheduleRunning: Bool {
        didSet {
            UserDefaults.standard.set(
                self.isScheduleRunning,
                forKey: AppStorageKey.isScheduleRunning.key) }
    }
    
    func requestNotificationPermission() {
        
        Task {
            
            do {
                let center = UNUserNotificationCenter.current()
                self.isAuthorized = try await center.requestAuthorization(options: [.sound, .alert, .badge])
                self.isAskedForPermission = true
            } catch {
                
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func scheduleNotification( _ count: Int) {
        
        if !self.isAuthorized { return }
        
        // TODO sts 22.02.2025 - error message localize
        let content = UNMutableNotificationContent()
        content.title = "Neue Likes"
        content.body = "Du hast soeben deinen \(count). Like von 'Xyz' erhalten!."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        self.sendNotification(request)
    }
    
    func scheduleNotificationByDate( _ date: DateComponents) {
        
        if self.isScheduleRunning { return }
        
        // TODO sts 22.02.2025 - error message localize
        let content = UNMutableNotificationContent()
        content.title = "Nachricht über News"
        content.body = "Komme zurück und schaue nach den neuesten Stand der Dinge."
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        self.sendNotification(request)
        
        self.isScheduleRunning = true
    }
    
    private func sendNotification( _ request: UNNotificationRequest) {
        
        Task {
            
            do {
                let center = UNUserNotificationCenter.current()
                try await center.add(request)
            } catch {
                
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

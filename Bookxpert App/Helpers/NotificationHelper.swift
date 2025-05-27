//
//  NotificationHelper.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 28/05/25.
//

import Foundation
import UserNotifications

class NotificationHelper {
    
    static func triggerDeletionNotification(for id: String) {
        // Request permission if not already granted
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                requestPermission()
                return
            }
            scheduleNotification(for: id)
        }
    }

    private static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    private static func scheduleNotification(for id: String) {
        let content = UNMutableNotificationContent()
        content.title = "Product Deleted"
        content.body = "The product with ID \(id) has been deleted from your list."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for deletion.")
            }
        }
    }
}

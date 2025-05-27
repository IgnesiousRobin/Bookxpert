//
//  NotificationSettingsManager.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 28/05/25.
//

import Foundation

class NotificationSettingsManager {
    static let shared = NotificationSettingsManager()
    private let key = "notifications_enabled"

    var isNotificationEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

//
//  NotificationManager.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 03/05/25.
//

import SwiftUI

class NotificationManager: ObservableObject {
    @Published var notifications: [NotificationItem] = []


    func show(message: String) {
        let newNotification = NotificationItem(title: "Nuevo Mensaje", message: message, date: Date(), imageName: "")
        notifications.insert(newNotification, at: 0)
    }
    func agregarNotificacion(title: String, message: String, imageName: String? = nil, date: Date = Date()) {
        let nueva = NotificationItem(title: title, message: message, date: date, imageName: imageName)
        notifications.insert(nueva, at: 0)
    }

}


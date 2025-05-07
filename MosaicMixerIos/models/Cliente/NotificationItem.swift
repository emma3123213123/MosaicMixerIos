//
//  NotificationItem.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 03/05/25.
//

import Foundation

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let date: Date
    let imageName: String? // nombre de la imagen (opcional)

}

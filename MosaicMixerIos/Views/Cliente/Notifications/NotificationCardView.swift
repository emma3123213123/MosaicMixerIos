//
//  NotificationCardView.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 03/05/25.
//

import SwiftUICore

struct NotificationCardView: View {
    var notification: NotificationItem

    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                if let imageName = notification.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                        .cornerRadius(8)
                }

                Text(notification.title)
                    .font(.headline)
                    .foregroundColor(.black)

                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.gray)

            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }

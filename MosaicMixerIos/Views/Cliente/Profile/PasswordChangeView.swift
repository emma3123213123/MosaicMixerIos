//
//  PasswordChangeView.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 03/05/25.
//

import SwiftUI

struct PasswordChangeView: View {
    @ObservedObject var user: User
    @State private var newPassword = ""

    var body: some View {
        VStack(spacing: 20) {
            SecureField("Nueva contraseña", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Guardar") {
                user.password = newPassword
                newPassword = ""
            }
            .foregroundColor(.blue)

            Spacer()
        }
        .padding()
        .navigationTitle("Cambiar Contraseña")
    }
}

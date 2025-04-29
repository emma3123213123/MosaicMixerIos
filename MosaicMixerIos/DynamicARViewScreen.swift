//
//  DynamicARViewScreen.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 29/04/25.
//

import SwiftUI

struct DynamicARViewScreen: View {
    var selectedColors: [ColorInfo]
    var modelName: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            DynamicARViewContainer(selectedColors: selectedColors, modelName: modelName)
                .edgesIgnoringSafeArea(.all)

            // Botón de cerrar
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
                    .padding()
            }
        }
    }
}

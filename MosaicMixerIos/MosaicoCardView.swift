//
//  MosaicoCardView.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 26/04/25.
//

import SwiftUI

struct MosaicoCardView: View {
    let mosaico: Mosaico
    let scale: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(mosaico.imagen)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 160)
                .clipped()
                .cornerRadius(12)

            Text(mosaico.nombre)
                .font(.headline)
                .foregroundColor(.black)

            Text(mosaico.descripcion)
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(mosaico.precio)
                .font(.subheadline)
                .bold()
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .scaleEffect(scale)
        .animation(.easeOut(duration: 0.3), value: scale)
    }
}

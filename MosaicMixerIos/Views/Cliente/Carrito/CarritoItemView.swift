//
//  CarritoItemView.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 03/05/25.
//

import SwiftUI

struct CarritoItemView: View {
    let item: CarritoItem
    var eliminar: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.mosaico.nombre)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: eliminar) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }

            Text("Colores:")
                .font(.subheadline)
                .foregroundColor(.gray)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(item.colores, id: \.id) { color in
                        VStack {
                            Image(color.imageName)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .cornerRadius(6)

                            Text(color.name)
                                .font(.caption2)
                        }
                    }
                }
            }

            let precioM2 = Double(item.mosaico.precio.replacingOccurrences(of: "$", with: "")) ?? 0
            let subtotalColores = item.colores
                .compactMap { Double($0.price.replacingOccurrences(of: "$", with: "")) }
                .reduce(0, +)
            let total = (precioM2 * item.metrosCuadrados) + subtotalColores

            HStack {
                Text("m²: \(item.metrosCuadrados, specifier: "%.1f")")
                Spacer()
                Text("Total: $\(total, specifier: "%.2f")")
                    .bold()
            }
            .font(.caption)
            .foregroundColor(.black)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

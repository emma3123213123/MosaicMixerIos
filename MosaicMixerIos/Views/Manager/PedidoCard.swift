//
//  PedidoCard.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 04/05/25.
//

import SwiftUICore

struct PedidoCard: View {
    let pedido: Pedido

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(pedido.cliente)
                    .font(.headline)
                Spacer()
                Text(pedido.estado)
                    .font(.caption)
                    .foregroundColor(pedido.estado.lowercased() == "entregado" ? .green : .orange)
                    .padding(6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
            }

            Text("Fecha: \(pedido.fecha.formatted(date: .abbreviated, time: .shortened))")
                .font(.caption)
                .foregroundColor(.gray)

            ForEach(pedido.mosaicos) { mosaico in
                HStack {
                    Text("• \(mosaico.nombre)")
                    Spacer()
                    Text("\(mosaico.cantidad, specifier: "%.1f") m²")
                }
                .font(.subheadline)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

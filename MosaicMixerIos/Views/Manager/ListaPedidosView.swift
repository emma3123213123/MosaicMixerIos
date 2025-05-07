//
//  ListaPedidosView.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 03/05/25.
//

import SwiftUI

struct Pedido: Identifiable {
    let id = UUID()
    let cliente: String
    let fecha: Date
    let mosaicos: [MosaicoPedido]
    var estado: String  // <- CAMBIAR de 'let' a 'var'
}
    
struct MosaicoPedido: Identifiable {
    let id = UUID()
    let nombre: String
    let cantidad: Double
}

struct ListaPedidosView: View {
        @EnvironmentObject var pedidoManager: PedidoManager

        var body: some View {
            VStack {
                Text("Pedidos")
                    .font(.title2.bold())
                    .padding(.top, 16)

                if pedidoManager.pedidos.isEmpty {
                    Spacer()
                    Text("No hay pedidos por el momento.")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(pedidoManager.pedidos) { pedido in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(pedido.cliente)
                                            .font(.headline)
                                        Spacer()
                                        Text(pedido.estado)
                                            .font(.subheadline)
                                            .foregroundColor(pedido.estado == "Entregado" ? .green : .orange)
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
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }

               
            }
            .background(Color.white)
            .ignoresSafeArea(edges: .bottom)
        }
    }

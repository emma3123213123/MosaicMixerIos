//
//  PedidoManager.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 03/05/25.
//

// PedidoManager.swift
import SwiftUI

class PedidoManager: ObservableObject {
    @Published var pedidos: [Pedido] = []  // Lista de pedidos

    // Aquí agregarías métodos para manejar los pedidos
    func agregarPedido(_ pedido: Pedido) {
        pedidos.append(pedido)
    }

    func eliminarPedido(at index: Int) {
        pedidos.remove(at: index)
    }

    func actualizarEstadoDelPedido(at index: Int, estado: String) {
        pedidos[index].estado = estado
    }
}

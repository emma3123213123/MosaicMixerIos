//
//  CarritoManager.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 03/05/25.
//

import Foundation

class CarritoManager: ObservableObject {
    @Published var items: [CarritoItem] = []

    func agregarItem(_ item: CarritoItem) {
        items.append(item)
    }

    func eliminarItem(at index: Int) {
        items.remove(at: index)
    }

    func totalFinal() -> Double {
        items.reduce(0) { total, item in
            let precioM2 = Double(item.mosaico.precio.replacingOccurrences(of: "$", with: "")) ?? 0
            let subtotalColores = item.colores
                .compactMap { Double($0.price.replacingOccurrences(of: "$", with: "")) }
                .reduce(0, +)
            return total + (precioM2 * item.metrosCuadrados) + subtotalColores
        }
    }
}

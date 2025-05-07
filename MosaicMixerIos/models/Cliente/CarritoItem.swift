//
//  CarritoItem.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 03/05/25.
//

import Foundation

struct CarritoItem: Identifiable {
    let id = UUID()
    let mosaico: Mosaico
    let colores: [ColorInfo]
    let metrosCuadrados: Double
}

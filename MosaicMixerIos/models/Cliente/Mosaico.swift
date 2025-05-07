//
//  Mosaico.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 25/04/25.
//

import Foundation

struct Mosaico: Identifiable,Equatable {
    let id = UUID()
    let nombre: String
    let descripcion: String
    let imagen: String
    let precio: String
}

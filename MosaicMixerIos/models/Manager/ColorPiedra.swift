//
//  ColorPiedra.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 08/05/25.
//

import FirebaseFirestore

struct ColorPiedra: Identifiable, Codable {
    @DocumentID var id: String?
    var nombre: String
    var precio: String
    var imagenURL: String
}

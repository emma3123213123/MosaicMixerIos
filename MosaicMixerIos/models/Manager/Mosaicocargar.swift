//
//  Mosaicocargar.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 08/05/25.
//

import Foundation
import FirebaseFirestore

struct MosaicoCharge: Identifiable, Codable {
    @DocumentID var id: String?  // <- importante para obtener el id del documento Firestore
    var nombre: String
    var descripcion1: String
    var descripcion2: String
    var precio: String
    var imagenURL: String?
    var usdzURL: String?
    var grupo: String
    var fecha: Date = Date()
}

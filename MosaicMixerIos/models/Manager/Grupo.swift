//
//  Grupo.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 08/05/25.
//
import Foundation

struct Grupo: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var nombre: String
    var descripcion: String
    var imagenURL: String
    var fechaCreacion: Date = Date()

    // Equatable automático: como todas las propiedades son Equatable, no necesitas escribir nada más.
}

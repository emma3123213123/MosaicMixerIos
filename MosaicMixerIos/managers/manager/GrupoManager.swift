//
//  GrupoManager.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 08/05/25.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

class GrupoManager {
    static let shared = GrupoManager()
    private let storage = Storage.storage()
    private let db = Firestore.firestore()

    private init() {}

    
    func editarGrupo(grupo: Grupo, nuevoNombre: String, nuevaDescripcion: String, nuevaImagen: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        let grupoRef = db.collection("grupos").document(grupo.id)

        var datos: [String: Any] = [
            "nombre": nuevoNombre,
            "descripcion": nuevaDescripcion
        ]

        if let nuevaImagen = nuevaImagen,
           let imageData = nuevaImagen.jpegData(compressionQuality: 0.8) {

            let storageRef = storage.reference().child("grupos/\(grupo.id)/imagen.jpg")

            storageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    guard let imageURL = url?.absoluteString else {
                        completion(.failure(NSError(domain: "URL inválida", code: 0)))
                        return
                    }

                    datos["imagenURL"] = imageURL

                    grupoRef.updateData(datos) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                }
            }
        } else {
            // Sin nueva imagen
            grupoRef.updateData(datos) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    
    func guardarGrupo(nombre: String, descripcion: String, imagen: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imagen = imagen else {
            completion(.failure(NSError(domain: "Sin imagen", code: 0)))
            return
        }

        // 1. Convertir imagen a Data
        guard let imageData = imagen.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "No se pudo convertir la imagen", code: 1)))
            return
        }

        // 2. Crear ruta en Firebase Storage
        let idGrupo = UUID().uuidString
        let storageRef = storage.reference().child("grupos/\(idGrupo)/imagen.jpg")

        // 3. Subir imagen
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // 4. Obtener URL de la imagen
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let imageURL = url?.absoluteString else {
                    completion(.failure(NSError(domain: "URL inválida", code: 2)))
                    return
                }

                // 5. Crear documento en Firestore
                let grupo = Grupo(id: idGrupo, nombre: nombre, descripcion: descripcion, imagenURL: imageURL)

                do {
                    try self.db.collection("grupos").document(idGrupo).setData(from: grupo)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}

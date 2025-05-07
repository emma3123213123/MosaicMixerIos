//
//  UserService.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 06/05/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestore

/// Servicio para gestionar el documento `users/{uid}` en Firestore
final class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()

    /// Crea el documento tras el registro
    func createUser(
        uid: String,
        data: UserData,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            try db.collection("users")
                .document(uid)
                .setData(from: data) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
        } catch {
            completion(.failure(error))
        }
    }

    /// Obtiene el documento del usuario actual
    func fetchUser(
        uid: String,
        completion: @escaping (Result<UserData, Error>) -> Void
    ) {
        db.collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot,
                          let user = try? snapshot.data(as: UserData.self) {
                    completion(.success(user))
                } else {
                    completion(.failure(
                        NSError(domain: "", code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Documento no encontrado"])
                    ))
                }
            }
    }

    /// Actualiza campos del perfil
    func updateUser(
        uid: String,
        fields: [String: Any],
        completion: @escaping (Error?) -> Void
    ) {
        db.collection("users")
            .document(uid)
            .updateData(fields, completion: completion)
    }
}

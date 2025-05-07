//
//  ProfileViewModel.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 06/05/25.
//

import Foundation
import FirebaseAuth

final class ProfileViewModel: ObservableObject {
    @Published var userData = UserData() // ← Ya no es opcional

    private let service = UserService.shared

    func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        service.fetchUser(uid: uid) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.userData = user
                case .failure(let error):
                    print("❌ Error al cargar perfil: \(error.localizedDescription)")
                }
            }
        }
    }

    func saveChanges() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ UID no disponible")
            return
        }

        // No necesitamos hacer guard para userData porque ya no es opcional
        let data = userData

        // Solo actualizamos campos editables
        let fields: [String: Any] = [
            "name": data.name,
            "email": data.email,
            "phone": data.phone
        ]

        service.updateUser(uid: uid, fields: fields) { error in
            if let error = error {
                print("❌ Error al guardar: \(error.localizedDescription)")
            } else {
                print("✅ Cambios guardados")
            }
        }
    }

}

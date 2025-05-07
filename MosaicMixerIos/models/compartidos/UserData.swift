import Foundation
import FirebaseFirestore

/// Representa el documento `users/{uid}` en Firestore
struct UserData: Identifiable, Codable {
    @DocumentID var id: String?

    var name: String
    var email: String
    var phone: String
    var role: String      // "client" o "manager"
    var photoURL: String?
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case role
        case photoURL
        case createdAt
    }

    // 🆕 Inicializador con valores por defecto
    init(
        id: String? = nil,
        name: String = "",
        email: String = "",
        phone: String = "",
        role: String = "client",
        photoURL: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.role = role
        self.photoURL = photoURL
        self.createdAt = createdAt
    }
}

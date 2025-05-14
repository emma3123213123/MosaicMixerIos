import Firebase
import FirebaseStorage
import FirebaseFirestore

class ColorManager {
    static let shared = ColorManager()
    private let storage = Storage.storage()
    private let db = Firestore.firestore()

    private init() {}

    // Guardar color nuevo
    func guardarColor(nombre: String, precio: String, imagen: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imagen = imagen else {
            completion(.failure(NSError(domain: "Sin imagen", code: 0)))
            return
        }

        guard let imageData = imagen.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "No se pudo convertir la imagen", code: 1)))
            return
        }

        let idColor = UUID().uuidString
        let storageRef = storage.reference().child("colores/\(idColor)/imagen.jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
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
                    completion(.failure(NSError(domain: "URL inválida", code: 2)))
                    return
                }

                let color = ColorPiedra(nombre: nombre, precio: precio, imagenURL: imageURL)

                do {
                    try self.db.collection("colores").document(idColor).setData(from: color)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

    // ✅ Actualizar color existente
    func actualizarColor(id: String, nuevoNombre: String, nuevoPrecio: String, nuevaImagen: UIImage?, urlImagenAnterior: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let colorRef = db.collection("colores").document(id)

        if let nuevaImagen = nuevaImagen, let imageData = nuevaImagen.jpegData(compressionQuality: 0.8) {
            let storageRef = storage.reference().child("colores/\(id)/imagen.jpg")

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

                    guard let nuevaURL = url?.absoluteString else {
                        completion(.failure(NSError(domain: "URL inválida", code: 0)))
                        return
                    }

                    colorRef.updateData([
                        "nombre": nuevoNombre,
                        "precio": nuevoPrecio,
                        "imagenURL": nuevaURL
                    ]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                }
            }
        } else {
            // Solo nombre y precio
            colorRef.updateData([
                "nombre": nuevoNombre,
                "precio": nuevoPrecio
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}

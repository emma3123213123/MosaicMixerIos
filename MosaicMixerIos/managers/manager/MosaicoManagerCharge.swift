import FirebaseStorage
import FirebaseFirestore

class MosaicoManagerCharge {
    static let shared = MosaicoManagerCharge()

    
    
    
    func guardarMosaico(
        nombre: String,
        descripcion1: String,
        descripcion2: String,
        precio: String,
        grupo: String,
        imagen: UIImage,
        archivoUSDZ: URL?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let imagenData = imagen.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Imagen inválida", code: 0, userInfo: nil)))
            return
        }

        let storage = Storage.storage()
        let carpetaBase = "mosaicos/\(grupo)/\(nombre)"
        let imagenRef = storage.reference().child("\(carpetaBase)/\(nombre).jpg")

        imagenRef.putData(imagenData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            imagenRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                let imagenURL = url?.absoluteString ?? ""

                // ⬇️ Si existe archivo USDZ, lo subimos
                if let archivoUSDZ = archivoUSDZ {
                    let accesoPermitido = archivoUSDZ.startAccessingSecurityScopedResource()
                    defer { if accesoPermitido { archivoUSDZ.stopAccessingSecurityScopedResource() } }

                    do {
                        let archivoData = try Data(contentsOf: archivoUSDZ)
                        let archivoRef = storage.reference().child("\(carpetaBase)/\(nombre).usdc")

                        archivoRef.putData(archivoData, metadata: nil) { metadata, error in
                            if let error = error {
                                print("❌ Error al subir USDZ: \(error.localizedDescription)")
                                // Continuamos sin fallar toda la operación
                            } else {
                                print("✅ Archivo USDZ subido correctamente")
                            }

                            self.guardarEnFirestore(
                                nombre: nombre,
                                descripcion1: descripcion1,
                                descripcion2: descripcion2,
                                precio: precio,
                                grupo: grupo,
                                imagenURL: imagenURL,
                                completion: completion
                            )
                        }
                    } catch {
                        print("❌ Error al leer USDZ: \(error.localizedDescription)")
                        self.guardarEnFirestore(
                            nombre: nombre,
                            descripcion1: descripcion1,
                            descripcion2: descripcion2,
                            precio: precio,
                            grupo: grupo,
                            imagenURL: imagenURL,
                            completion: completion
                        )
                    }

                } else {
                    // No hay archivo USDZ, seguimos directo a Firestore
                    self.guardarEnFirestore(
                        nombre: nombre,
                        descripcion1: descripcion1,
                        descripcion2: descripcion2,
                        precio: precio,
                        grupo: grupo,
                        imagenURL: imagenURL,
                        completion: completion
                    )
                }
            }
        }
    }

    private func guardarEnFirestore(
        nombre: String,
        descripcion1: String,
        descripcion2: String,
        precio: String,
        grupo: String,
        imagenURL: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let db = Firestore.firestore()
        let mosaicoData: [String: Any] = [
            "nombre": nombre,
            "descripcion1": descripcion1,
            "descripcion2": descripcion2,
            "precio": Double(precio) ?? 0.0,
            "grupo": grupo,
            "imagenURL": imagenURL,
            "fechaCreacion": Timestamp()
        ]

        db.collection("mosaicos").addDocument(data: mosaicoData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    func actualizarMosaico(
        id: String,
        nombre: String,
        descripcion1: String,
        descripcion2: String,
        precio: String,
        grupo: String,
        imagen: UIImage?,
        archivoUSDZ: URL?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let db = Firestore.firestore()
        let docRef = db.collection("mosaicos").document(id)
        var data: [String: Any] = [
            "nombre": nombre,
            "descripcion1": descripcion1,
            "descripcion2": descripcion2,
            "precio": precio,
            "grupo": grupo,
            "fecha": Timestamp()
        ]

        let carpeta = "mosaicos/\(grupo)/\(nombre)"
        let storage = Storage.storage()

        func finalizarGuardado(imagenURL: String?) {
            if let url = imagenURL {
                data["imagenURL"] = url
            }

            docRef.setData(data, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }

        if let imagen = imagen, let imgData = imagen.jpegData(compressionQuality: 0.8) {
            let imgRef = storage.reference().child("\(carpeta)/\(nombre).jpg")
            imgRef.putData(imgData, metadata: nil) { _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                imgRef.downloadURL { url, _ in
                    finalizarGuardado(imagenURL: url?.absoluteString)
                }
            }
        } else {
            finalizarGuardado(imagenURL: nil)
        }

        if let archivo = archivoUSDZ {
            let acceso = archivo.startAccessingSecurityScopedResource()
            defer { if acceso { archivo.stopAccessingSecurityScopedResource() } }

            if let data = try? Data(contentsOf: archivo) {
                let archivoRef = storage.reference().child("\(carpeta)/\(nombre).usdz")
                archivoRef.putData(data, metadata: nil)
            }
        }
    }

}

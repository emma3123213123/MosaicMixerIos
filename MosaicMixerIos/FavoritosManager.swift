import SwiftUI

// Estructura de datos que representa un mosaico favorito
struct MosaicoFavorito: Identifiable, Equatable {
    let id = UUID()
    let mosaico: Mosaico
    let colores: [ColorInfo]
    
    // Imagen del modelo 3D renderizado con colores aplicados
    let previewImage: UIImage? // Nueva propiedad

    // Computado para obtener el precio total de los colores seleccionados
    var precioTotal: String {
        let total = colores.compactMap { Double($0.price) }.reduce(0, +)
        return String(format: "%.2f", total)
    }

    // Comparación para saber si dos mosaicos favoritos son iguales
    static func ==(lhs: MosaicoFavorito, rhs: MosaicoFavorito) -> Bool {
        lhs.mosaico.id == rhs.mosaico.id &&
        lhs.colores == rhs.colores
    }
}

// Clase para gestionar los favoritos
class FavoritosManager: ObservableObject {
    // Lista de mosaicos favoritos
    @Published var favoritos: [MosaicoFavorito] = []

    // Agregar un mosaico a los favoritos con imagen
    func agregar(_ mosaico: Mosaico, colores: [ColorInfo], previewImage: UIImage? = nil) {
        let nuevoFavorito = MosaicoFavorito(mosaico: mosaico, colores: colores, previewImage: previewImage)
        if !favoritos.contains(nuevoFavorito) {
            favoritos.append(nuevoFavorito)
        }
    }

    // Eliminar un mosaico de los favoritos
    func eliminar(_ favorito: MosaicoFavorito) {
        favoritos.removeAll { $0 == favorito }
    }
}

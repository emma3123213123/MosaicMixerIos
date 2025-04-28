import SwiftUI

struct VistaFavoritosView: View {
    var favorito: MosaicoFavorito

    var body: some View {
        VStack {
            // 📛 Nombre del mosaico
            Text(favorito.mosaico.nombre)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20)

            // 🖼 Imagen representativa usando el primer color
            if let primeraImagen = favorito.colores.first?.imageName {
                Image(primeraImagen)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .cornerRadius(12)
                    .padding(20)
            } else {
                Text("Sin imagen disponible")
                    .foregroundColor(.gray)
                    .padding()
            }

            // 📝 Detalles
            VStack(alignment: .leading, spacing: 8) {
                Text("Colores: \(favorito.colores.map { $0.name }.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Precio Total: $\(favorito.precioTotal)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding()
        .navigationBarTitle("Detalles del Mosaico", displayMode: .inline)
    }
}

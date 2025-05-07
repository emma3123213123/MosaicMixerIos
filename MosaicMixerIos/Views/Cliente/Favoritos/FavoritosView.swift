import SwiftUI

struct FavoritosView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var favoritosManager: FavoritosManager

    var body: some View {
        VStack(spacing: 0) {
            // Título con apariencia de barra superior
            HStack {
            Spacer()
                Text("Favoritos")
                .font(.title2.bold())
                .foregroundColor(.black) // 🔧 Aseguramos color visible
                .padding(.vertical, 16)
                Spacer()
                }
            .background(Color.white) // 🔧 Fondo claro para contraste


            // Lista de favoritos o mensaje vacío
            if favoritosManager.favoritos.isEmpty {
                Spacer()
                Text("No hay mosaicos favoritos.")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(favoritosManager.favoritos) { favorito in
                            HStack(alignment: .top, spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(favorito.mosaico.nombre)
                                        .font(.headline)

                                    if let uiImage = favorito.previewImage {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 80)
                                            .cornerRadius(10)
                                    } else {
                                        Image(favorito.mosaico.imagen)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 80)
                                            .cornerRadius(10)
                                    }
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Colores:")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)

                                    ForEach(favorito.colores, id: \.id) { color in
                                        Text("- \(color.name): \(color.price)")
                                            .font(.caption)
                                    }

                                    Text("Total: $\(favorito.precioTotal)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Spacer()

                                    Button(action: {
                                        favoritosManager.eliminar(favorito)
                                    }) {
                                        Label("Eliminar", systemImage: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .padding(.top, 6)
                                }

                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

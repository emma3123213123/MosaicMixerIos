import SwiftUI

struct FavoritosView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var favoritosManager: FavoritosManager

    var body: some View {
        VStack(spacing: 0) {
            // 🏷️ Título centrado
            Text("Favoritos")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)

            // 📜 Lista de mosaicos favoritos
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
                                    
                                    // Imagen del modelo con colores aplicados (si existe), si no, la del mosaico base
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

            // ⬛ Bottom bar
            HStack {
                Spacer()
                Image(systemName: "cart")
                Spacer()
                Image(systemName: "heart.fill")
                Spacer()
                Image(systemName: "house")
                Spacer()
                Image(systemName: "bell")
                Spacer()
                Image(systemName: "person")
                Spacer()
            }
            .foregroundColor(.white)
            .font(.system(size: 25))
            .padding(25)
            .background(Color.black)
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

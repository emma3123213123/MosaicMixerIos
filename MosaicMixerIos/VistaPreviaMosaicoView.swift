import SwiftUI
import RealityKit

struct VistaPreviaMosaicoView: View {
    let mosaico: Mosaico
    let selectedColors: [ColorInfo]
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var favoritosManager: FavoritosManager


    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // 🔝 Header con botón Back y título
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.blue)
                    }
                    .padding(.leading, 16)

                    Spacer()
                }
                .padding(.top, 0)

                // 📛 Título del mosaico justo debajo del botón
                Text(mosaico.nombre)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                    .padding(.bottom, 10)

                // 📜 Scroll solo para contenido intermedio
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        // 🎨 Modelo más grande y a lo ancho
                        ARViewContainer(selectedColors: selectedColors, modelName: mosaico.nombre)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.60)
                            .cornerRadius(12)

                        // 🔘 Iconos de acción
                        // 🔘 Iconos de acción
                        HStack(spacing: 50) {
                            Button(action: {
                                favoritosManager.agregar(mosaico, colores: selectedColors)
                            }) {
                                Image(systemName: "heart")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }

                            Button(action: {
                                print("📤 Compartir")
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }

                            Button(action: {
                                print("🧊 Realidad Aumentada")
                            }) {
                                Image(systemName: "arkit")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                        }

                        .padding(.top, 10)
                        .padding(.bottom, 80) // espacio para bottom bar
                    }
                    .padding(.horizontal)
                }

                // ⬇️ Bottom bar fijo
                HStack {
                    Spacer()
                    Image(systemName: "cart")
                    Spacer()
                    NavigationLink(destination: FavoritosView()) {
                    Image(systemName: "heart")
                    };
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
        }
        .navigationBarHidden(true)
    }
}

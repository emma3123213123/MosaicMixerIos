import SwiftUI
import RealityKit

struct VistaPreviaMosaicoView: View {
    let mosaico: Mosaico
    let selectedColors: [ColorInfo]
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var favoritosManager: FavoritosManager
    @State private var showARView = false
    @State private var showEmbeddedAR = true
    @State private var showARFullScreen = false

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
                        if showEmbeddedAR {
                            StaticARViewContainer(selectedColors: selectedColors, modelName: mosaico.imagen, isStatic: true)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.60)
                                .cornerRadius(12)
                                .shadow(radius: 10)
                        }
                        
                        // 🔘 Iconos de acción
                        HStack(spacing: 50) {
                            Button(action: {
                                favoritosManager.agregar(mosaico, colores: selectedColors)
                            }) {
                                Image(systemName: "heart")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(Circle().fill(Color.white).shadow(radius: 5))
                            }

                            Button(action: {
                                print("📤 Compartir")
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(Circle().fill(Color.white).shadow(radius: 5))
                            }

                            Button(action: {
                                showEmbeddedAR = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    showARFullScreen = true
                                }
                            }) {
                                Image(systemName: "arkit")
                                    .font(.title)
                                    .padding(10)
                                    .background(Circle().fill(Color.white).shadow(radius: 5))
                            }
                            .fullScreenCover(isPresented: $showARFullScreen, onDismiss: {
                                showEmbeddedAR = true
                            }) {
                                DynamicARViewScreen(
                                    selectedColors: selectedColors,
                                    modelName: mosaico.imagen
                                )
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 20) // Ajuste para espacio

                    }
                    .padding(.horizontal)
                }

                Spacer() // Esto empuja el contenido hacia arriba
            }
        }
        .navigationBarHidden(true)
    }
}

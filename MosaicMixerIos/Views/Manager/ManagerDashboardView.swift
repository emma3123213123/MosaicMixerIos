import SwiftUI
import FirebaseAuth

struct ManagerDashboardView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var seleccion: String? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 🌟 Barra fija superior con Logout
                HStack {
                    Spacer()
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                            isLoggedIn = false
                        } catch {
                            print("❌ Error al cerrar sesión: \(error.localizedDescription)")
                        }
                    }) {
                        Image(systemName: "power.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                // 🚀 Scrollable content
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Header del Perfil
                        ZStack {
                            Color(hex: "#F2F6FC")
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))

                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .background(Color(hex: "#E0E7FF"))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))

                                Text("Emmanuel Olvera")
                                    .font(.title2.bold())
                                    .foregroundColor(Color(hex: "#111827"))

                                Text("emmanuel@correo.com")
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "#6B7280"))
                            }
                            .padding()
                        }

                        // MARK: - Opciones de Menú
                        VStack(spacing: 16) {
                            dashboardItem(icon: "cube.box", label: "Mis Mosaicos") {
                                seleccion = "mosaicos"
                            }
                            dashboardItem(icon: "square.grid.2x2", label: "Mis Grupos") {
                                seleccion = "grupos"
                            }
                            dashboardItem(icon: "paintpalette", label: "Mis Colores") {
                                seleccion = "colores"
                            }
                            dashboardItem(icon: "doc.plaintext", label: "Mis Pedidos") {}
                            dashboardItem(icon: "clock.arrow.circlepath", label: "Historial") {}
                            dashboardItem(icon: "person.crop.circle", label: "Perfil") {}
                            dashboardItem(icon: "lock.circle", label: "Cambiar Contraseña") {}
                            dashboardItem(icon: "questionmark.circle", label: "Ayuda") {}
                            dashboardItem(icon: "info.circle", label: "Acerca de") {}
                            dashboardItem(icon: "doc.text", label: "Términos y Condiciones") {}
                        }
                        .padding()
                    }
                    .padding(.bottom, 50)
                }
                .background(Color.white)
            }
            .background(Color.white.ignoresSafeArea())
            .navigationDestination(isPresented: Binding(
                get: { seleccion != nil },
                set: { if !$0 { seleccion = nil } }
            )) {
                switch seleccion {
                case "colores":
                    ListaColoresView()
                case "grupos":
                    ListaGruposView()
                case "mosaicos":
                    ListaMosaicosView()
                default:
                    EmptyView()
                }
            }
        }
    }

    // MARK: - Ítem personalizado
    @ViewBuilder
    func dashboardItem(icon: String, label: String, color: Color = .black, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#F3F4F6"))
                        .frame(width: 40, height: 40)

                    Image(systemName: icon)
                        .foregroundColor(color)
                }

                Text(label)
                    .font(.body)
                    .foregroundColor(color)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.black.opacity(0.3))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

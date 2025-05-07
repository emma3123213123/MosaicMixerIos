import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            // 🔓 Botón de Logout arriba a la derecha
            HStack {
                Spacer()
                Button(action: {
                    do {
                        try Auth.auth().signOut()
                        isLoggedIn = false
                    } catch {
                        print("Error al cerrar sesión: \(error.localizedDescription)")
                    }
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                }
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // 🧑‍🎤 Header
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.blue.opacity(0.1))
                            .frame(height: 220)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)

                            Text(viewModel.userData.name)
                                .font(.title2.bold())
                                .foregroundColor(.black)
                        }
                    }

                    // ✏️ Campos editables
                    VStack(spacing: 14) {
                        EditableField(icon: "person", placeholder: "Nombre", text: $viewModel.userData.name)
                        EditableField(icon: "envelope", placeholder: "Correo", text: $viewModel.userData.email)
                        EditableField(icon: "phone", placeholder: "Teléfono", text: $viewModel.userData.phone)
                        EditableSecureField(icon: "lock", placeholder: "Contraseña", text: .constant(""))
                    }
                    .padding(.horizontal)

                    // ⚙️ Acciones
                    VStack(spacing: 12) {
                        ActionButton(title: "Cambiar Contraseña") {
                            print("Cambiar contraseña")
                        }

                        ActionButton(title: "Eliminar Cuenta", isDestructive: true) {
                            print("Eliminar cuenta")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top, 10)
            }

            // 💾 Botón Guardar
            VStack {
                ActionButton(title: "Guardar Datos", isPrimary: true) {
                    viewModel.saveChanges()
                }
                .padding()
            }
            .background(Color.white)
        }
        .onAppear {
            viewModel.loadUser()
        }
        .background(Color.white.ignoresSafeArea())
    }
}


// MARK: - Subcomponentes

struct EditableField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.08))
            .frame(height: 50)
            .overlay(
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                        .padding(.leading, 12)
                    TextField(placeholder, text: $text)
                        .foregroundColor(.black)
                        .padding(.trailing, 12)
                }
            )
    }
}

struct EditableSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.08))
            .frame(height: 50)
            .overlay(
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                        .padding(.leading, 12)
                    SecureField(placeholder, text: $text)
                        .foregroundColor(.black)
                        .padding(.trailing, 12)
                }
            )
    }
}

struct ActionButton: View {
    let title: String
    var isDestructive: Bool = false
    var isPrimary: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(buttonTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(buttonBackground)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }

    private var buttonBackground: Color {
        if isPrimary {
            return Color.blue
        } else if isDestructive {
            return Color.red.opacity(0.1)
        } else {
            return Color.gray.opacity(0.1)
        }
    }

    private var buttonTextColor: Color {
        if isDestructive {
            return .red
        } else if isPrimary {
            return .white
        } else {
            return .black
        }
    }
}

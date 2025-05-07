import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    // MARK: - Flags de sesión
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("isManager")  private var isManager: Bool  = false

    // MARK: - Campos de formulario
    @State private var nombre: String   = ""
    @State private var email: String    = ""
    @State private var password: String = ""
    @State private var registerError: String = ""

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // 📋 Encabezado
                    VStack(spacing: 12) {
                        Image(systemName: "square.grid.2x2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)

                        Text("Crea tu cuenta")
                            .font(.largeTitle.bold())
                            .foregroundColor(.black)
                    }
                    .padding(.top, 50)

                    // 📝 Formulario
                    VStack(spacing: 20) {
                        // Nombre
                        InputField(icon: "person",
                                   placeholder: "Nombre completo",
                                   text: $nombre)

                        // Email
                        InputField(icon: "envelope",
                                   placeholder: "correo@ejemplo.com",
                                   text: $email,
                                   keyboard: .emailAddress,
                                   autocapitalization: .never)

                        // Contraseña
                        SecureInputField(icon: "lock",
                                         placeholder: "********",
                                         text: $password)

                        // Botón Registrar
                        Button(action: registerUser) {
                            Text("Registrarse")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }

                        // Error
                        if !registerError.isEmpty {
                            Text(registerError)
                                .foregroundColor(.red)
                                .font(.caption)
                        }

                        // Separador
                        HStack {
                            Rectangle().frame(height: 1).foregroundColor(.orange)
                            Text("o").foregroundColor(.black).padding(.horizontal, 6)
                            Rectangle().frame(height: 1).foregroundColor(.purple)
                        }

                        // Google (pendiente)
                        Button(action: {
                            // Acción Google
                        }) {
                            HStack {
                                Image("google")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Continuar con Google")
                                    .foregroundColor(.black)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                        }

                        // Apple (pendiente)
                        Button(action: {
                            // Acción Apple
                        }) {
                            HStack {
                                Image(systemName: "applelogo")
                                Text("Continuar con Apple")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // ⚠️ Pie
                    VStack(spacing: 10) {
                        Text("Al continuar, aceptas nuestros Términos y Política de privacidad.")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 30)

                        // Link a LoginView si no tienes cuenta
                        NavigationLink(destination: LoginView()) {
                            Text("¿Ya tienes una cuenta? Inicia sesión")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Función de registro
    private func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                registerError = error.localizedDescription
                return
            }
            guard let user = result?.user else { return }

            // Actualiza el nombre en el perfil de FirebaseAuth
            let changeReq = user.createProfileChangeRequest()
            changeReq.displayName = nombre
            changeReq.commitChanges { _ in }

            // Asigna rol
            let role = (user.email?.lowercased() == "olveraemmanuelcbtis145@gmail.com") ? "manager" : "client"
            isManager = (role == "manager")
            isLoggedIn = true

            // Construye datos de usuario
            let userData = UserData(
                id: user.uid,
                name: nombre,
                email: email,
                phone: "", // Puedes agregar campo de teléfono en el formulario después
                role: role,
                photoURL: nil,
                createdAt: Date()
            )

            // Guarda en Firestore
            UserService.shared.createUser(uid: user.uid, data: userData) { result in
                switch result {
                case .success():
                    print("Usuario guardado correctamente en Firestore")
                case .failure(let error):
                    print("Error al guardar usuario: \(error.localizedDescription)")
                    registerError = "Error al guardar datos en Firestore"
                }
            }
        }
    }

}

// MARK: - Componentes auxiliares

/// Campo de texto normal con ícono
struct InputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .sentences

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(placeholder)
                .foregroundColor(.gray)
                .font(.subheadline)
            HStack {
                Image(systemName: icon).foregroundColor(.gray)
                TextField(placeholder, text: $text)
                    .keyboardType(keyboard)
                    .textInputAutocapitalization(autocapitalization)
                    .foregroundColor(.black)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
        }
    }
}

/// Campo de texto seguro con ícono
struct SecureInputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(placeholder)
                .foregroundColor(.gray)
                .font(.subheadline)
            HStack {
                Image(systemName: icon).foregroundColor(.gray)
                SecureField(placeholder, text: $text)
                    .foregroundColor(.black)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
        }
    }
}

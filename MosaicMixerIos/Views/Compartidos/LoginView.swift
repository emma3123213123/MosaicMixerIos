import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    // Persistimos estos flags para que RootView/SplashView los lea
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("isManager")  private var isManager: Bool  = false

    // Campos de formulario
    @State private var email: String       = ""
    @State private var password: String    = ""
    @State private var loginError: String  = ""

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 24) {
                // Logo y título
                VStack(spacing: 12) {
                    Image(systemName: "square.grid.2x2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)

                    Text("MosaicMixer")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                }
                .padding(.top, 50)

                // Formulario
                VStack(spacing: 20) {
                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Correo electrónico")
                            .foregroundColor(.gray)
                            .font(.subheadline)

                        HStack {
                            Image(systemName: "envelope").foregroundColor(.gray)
                            TextField("correo@ejemplo.com", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .textInputAutocapitalization(.never)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    }

                    // Contraseña
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Contraseña")
                            .foregroundColor(.gray)
                            .font(.subheadline)

                        HStack {
                            Image(systemName: "lock").foregroundColor(.gray)
                            SecureField("********", text: $password)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    }

                    // Botón iniciar sesión
                    Button(action: loginWithEmail) {
                        Text("Iniciar sesión")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    // Mostrar error si lo hay
                    if !loginError.isEmpty {
                        Text(loginError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    // Separador
                    HStack {
                        Rectangle().frame(height: 1).foregroundColor(.orange)
                        Text("o").foregroundColor(.black).padding(.horizontal, 6)
                        Rectangle().frame(height: 1).foregroundColor(.purple)
                    }

                    // Google Sign-In
                    Button(action: loginWithGoogle) {
                        Text("Continuar con Google")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Pie de página
                VStack(spacing: 10) {
                    Text("Al continuar, aceptas nuestros Términos y Política de privacidad.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)

                    NavigationLink(destination: RegisterView()) {
                        Text("¿No tienes una cuenta? Crear cuenta")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Métodos de autenticación

    private func loginWithEmail() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                loginError = error.localizedDescription
                return
            }
            // Definimos rol antes de marcar isLoggedIn
            determineUserType(email: email)
            isLoggedIn = true
        }
    }

    private func loginWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)

        guard let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first?.rootViewController else {
            loginError = "No se pudo obtener rootViewController"
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                loginError = error.localizedDescription
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                loginError = "Error obteniendo token de Google"
                return
            }
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { res, err in
                if let err = err {
                    loginError = err.localizedDescription
                    return
                }
                let email = res?.user.email ?? ""
                determineUserType(email: email)
                isLoggedIn = true
            }
        }
    }

    private func determineUserType(email: String) {
        // Persistimos el rol en AppStorage
        isManager = (email.lowercased() == "olveraemmanuelcbtis145@gmail.com")
    }
}

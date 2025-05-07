import SwiftUI

struct StartView: View {
    @State private var navigateToLogin = false
    @State private var continueAsGuest = false
    @State private var navigateToManager = false


    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.white, Color(.systemGray6)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()

                    Image(systemName: "square.grid.2x2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                        .padding(.bottom, 10)

                    Text("MosaicMixer")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)

                    Text("Crea - Mezcla - Inspira")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal)

                    // ✅ BOTÓN VENDEDOR
                    NavigationLink(destination: ManagerMainTabView(), isActive: $navigateToManager) {
                        EmptyView()
                    }

                    Button(action: {
                        navigateToManager = true
                    }) {
                        HStack {
                            Image(systemName: "briefcase.fill")
                            Text("Vende Tus Mosaicos")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // ✅ BOTÓN CLIENTE
                    NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                        Button(action: {
                            navigateToLogin = true
                        }) {
                            HStack {
                                Image(systemName: "person.fill")
                                Text("Iniciar sesión")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }

                    // Separador
                    HStack {
                        Rectangle().frame(height: 1).foregroundColor(.orange)
                        Text("o")
                            .foregroundColor(.black)
                        Rectangle().frame(height: 1).foregroundColor(.purple)
                    }
                    .padding(.horizontal)

                    // ✅ BOTÓN INVITADO
                    NavigationLink(destination: ClientMainTabView(), isActive: $continueAsGuest) {
                        Button(action: {
                            continueAsGuest = true
                        }) {
                            HStack {
                                Image(systemName: "eye.fill")
                                Text("Explorar sin cuenta")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                    }

                    Spacer()

                    Text("© 2025 MosaicMixer. Todos los derechos reservados.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }
            }
        }
    }
}

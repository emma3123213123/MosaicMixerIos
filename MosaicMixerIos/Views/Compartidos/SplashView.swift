  

import SwiftUI
import FirebaseAuth

struct SplashView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("isManager")  private var isManager: Bool = false
    @State private var showMain = false

    var body: some View {
        Group {
            if showMain {
                // Una vez que termine el splash, mostramos la vista adecuada
                if isLoggedIn {
                    if isManager {
                        ManagerMainTabView()
                    } else {
                        ClientMainTabView()
                    }
                } else {
                    StartView()
                }
            } else {
                // Tu UI de splash
                VStack {
                    Spacer()
                    Image(systemName: "square.grid.2x2")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    Text("MosaicMixer")
                        .font(.largeTitle.bold())
                        .padding(.top, 10)
                    Spacer()
                    ProgressView("Cargando...")
                        .padding(.bottom, 40)
                }
                .onAppear {
                    // Después de 2 s mostramos la siguiente pantalla
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showMain = true
                    }
                }
            }
        }
    }
}

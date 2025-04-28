import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        VStack {
            if isActive {
                // Después de que termine el splash, mostramos el ContentView
                ContentView()
            } else {
                // Aquí puedes poner tu logo y animaciones
                Image("perro") // Asegúrate de tener esta imagen en tus Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .opacity(1.0) // Puedes animar la opacidad si quieres un fade
                    .onAppear {
                        // Esto hace que el splash dure 3 segundos antes de cambiar
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Esto asegura que el fondo cubra toda la pantalla
        .background(Color(hex: "#2b2f30"))

        .edgesIgnoringSafeArea(.all) // Asegura que el fondo cubra la pantalla completa, incluso los márgenes
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

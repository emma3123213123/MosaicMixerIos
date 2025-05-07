import SwiftUI
import Firebase

@main
struct MosaicMixerIosApp: App {
    @StateObject var carritoManager = CarritoManager()
    @StateObject var favoritosManager = FavoritosManager()
    @StateObject var user = User(name: "Juan Pérez", email: "juan@example.com", phone: "773122333", password: "123456")
    @StateObject var notificationManager = NotificationManager()
    @StateObject var pedidoManager = PedidoManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(carritoManager)
                .environmentObject(favoritosManager)
                .environmentObject(user)
                .environmentObject(notificationManager)
                .environmentObject(pedidoManager)
        }
    }
}

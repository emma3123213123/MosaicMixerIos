import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var notificationManager: NotificationManager

    var body: some View {
        VStack(spacing: 0) {
            // Título centrado visible
            HStack {
                Spacer()
                Text("Notificaciones")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.vertical, 16)
            .background(Color.white) // Asegura contraste

            // Contenido scrollable
            ScrollView {
                VStack(spacing: 16) {
                    if notificationManager.notifications.isEmpty {
                        Spacer()
                        Text("No hay notificaciones.")
                            .foregroundColor(.gray)
                            .padding(.top, 100)
                        Spacer()
                    } else {
                        ForEach(notificationManager.notifications) { notification in
                            NotificationCardView(notification: notification)
                        }
                    }

                    // Botón de prueba (puedes moverlo donde prefieras)
                    Button("Agregar Notificación") {
                        notificationManager.agregarNotificacion(
                            title: "¡Bienvenido!",
                            message: "Gracias por usar Mosaic Mixer. Personaliza tus mosaicos favoritos.",
                            imageName: "bienvenido"
                        )
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

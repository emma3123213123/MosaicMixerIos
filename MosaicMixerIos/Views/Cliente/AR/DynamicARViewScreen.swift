import SwiftUI

struct DynamicARViewScreen: View {
    var selectedColors: [ColorInfo]
    var modelName: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // ✅ ARView en segundo plano
            DynamicARViewContainer(
                selectedColors: selectedColors,
                modelName: modelName
            )
            .edgesIgnoringSafeArea(.all)

            // ✅ Capa de botones superpuesta
            VStack {
                HStack {
                    // 🔵 Botón Duplicar (superior izquierda)
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.Name("DuplicateModel"), object: nil)
                    }) {
                        Label("Duplicar", systemImage: "plus.square.on.square")
                            .padding(10)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Spacer()
                    // ❌ Botón de cerrar (superior derecha)
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.red)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
}

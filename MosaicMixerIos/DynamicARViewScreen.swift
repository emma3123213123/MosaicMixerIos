import SwiftUI

struct DynamicARViewScreen: View {
    var selectedColors: [ColorInfo]
    var modelName: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            // ✅ Aquí es donde debe ir el ARViewContainer real
            DynamicARViewContainer(
                selectedColors: selectedColors,
                modelName: modelName
            )
            .edgesIgnoringSafeArea(.all)

            // Botón de cerrar
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
                    .padding()
            }
        }
    }
}

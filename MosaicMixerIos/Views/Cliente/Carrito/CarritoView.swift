import SwiftUI

struct CarritoView: View {
    @EnvironmentObject var carritoManager: CarritoManager

    var body: some View {
        VStack(spacing: 4) {
            // Título centrado
            HStack {
                Spacer()
                Text("Carrito")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                Spacer()
            }

            // Total alineado a la derecha
            HStack {
                Spacer()
                Text("Total: $\(Double(carritoManager.totalFinal()), specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 20)
            .padding(.horizontal)
            .padding(.bottom, 10)

            // Lista de productos
            ScrollView {
                VStack(spacing: 16) {
                    if carritoManager.items.isEmpty {
                        Spacer()
                        Text("Tu carrito está vacío.")
                            .foregroundColor(.gray)
                            .padding(.top, 100)
                        Spacer()
                    } else {
                        ForEach(Array(carritoManager.items.enumerated()), id: \.element.id) { index, item in
                            CarritoItemView(item: item) {
                                carritoManager.eliminarItem(at: index)
                            }
                        }

                        // Total general + botón
                        VStack(spacing: 12) {
                            Divider()

                            HStack {
                                Text("Total del carrito")
                                    .font(.headline)
                                Spacer()
                                Text("Total: $\(Double(carritoManager.totalFinal()), specifier: "%.2f")")
                                    .font(.headline.bold())
                            }

                            Button(action: {
                                // Acción: finalizar pedido
                            }) {
                                Text("Finalizar Pedido")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30) // Espacio al final por si se añade botón flotante luego
            }
        }
        .padding(.top, 16)
        .background(Color.white.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

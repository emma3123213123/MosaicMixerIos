import SwiftUI

struct AgregarColorView: View {
    @State private var nombreColor: String = ""
    @State private var precio: String = ""
    @State private var imagenColor: UIImage?
    @State private var mostrarPicker = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Agregar Color de Piedra")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.white)

            ScrollView {
                VStack(spacing: 20) {
                    campoDiseñado(titulo: "Nombre del color", texto: $nombreColor)

                    campoDiseñado(titulo: "Precio", texto: $precio)
                        .keyboardType(.decimalPad)

                    // Imagen
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Imagen del color")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        if let imagen = imagenColor {
                            Image(uiImage: imagen)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                                .cornerRadius(12)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 180)
                                .overlay(Text("Sin imagen seleccionada").foregroundColor(.gray))
                                .cornerRadius(12)
                        }

                        Button(action: {
                            mostrarPicker = true
                        }) {
                            Text("Seleccionar Imagen")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // Botón guardar
                    Button(action: {
                        print("Color guardado: \(nombreColor)")
                        // lógica para guardar color
                    }) {
                        Text("Guardar Color")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $mostrarPicker) {
            ImagePicker(image: $imagenColor)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    func campoDiseñado(titulo: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField(titulo, text: texto)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

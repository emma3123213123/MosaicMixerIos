import SwiftUI

struct AgregarColorView: View {
    @State private var nombreColor: String = ""
    @State private var precio: String = ""
    @State private var imagenColor: UIImage?
    @State private var mostrarPicker = false
    @State private var mensajeError: String?
    @State private var mostrandoCargando = false  // Nueva variable para mostrar el mensaje de "subiendo color"
    @State private var mostrarAlerta = false  // Nueva variable para mostrar el cuadro de alerta
    
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
                    
                    // Mostrar el mensaje de cargando cuando esté subiendo el color
                    if mostrandoCargando {
                        Text("Subiendo color...")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

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
                        guardarColor()
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

                    if let mensajeError = mensajeError {
                        Text(mensajeError)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $mostrarPicker) {
            ImagePicker(image: $imagenColor)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
        .alert(isPresented: $mostrarAlerta) {
            Alert(title: Text("¡Éxito!"),
                  message: Text("Color agregado exitosamente."),
                  dismissButton: .default(Text("OK")))
        }
    }

    // Lógica para guardar el color
    func guardarColor() {
        if nombreColor.isEmpty || precio.isEmpty || imagenColor == nil {
            mensajeError = "Por favor, llena todos los campos."
            return
        }

        mostrandoCargando = true  // Empieza a mostrar el mensaje de "subiendo color"

        // Guardar el color usando ColorManager
        ColorManager.shared.guardarColor(nombre: nombreColor, precio: precio, imagen: imagenColor) { result in
            mostrandoCargando = false  // Deja de mostrar el mensaje de "subiendo color"
            
            switch result {
            case .success():
                mostrarAlerta = true  // Mostrar la alerta de éxito
                nombreColor = ""
                precio = ""
                imagenColor = nil
            case .failure(let error):
                mensajeError = "Error: \(error.localizedDescription)"
            }
        }
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
                .foregroundColor(.black)  // Cambié el color del texto a negro
        }
        .padding(.horizontal)
    }
}

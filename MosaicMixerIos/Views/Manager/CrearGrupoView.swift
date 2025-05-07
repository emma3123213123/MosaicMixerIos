import SwiftUI

struct CrearGrupoView: View {
    @State private var nombreGrupo: String = ""
    @State private var descripcionGrupo: String = ""
    @State private var imagenSeleccionada: UIImage?
    @State private var mostrarPicker = false

    var body: some View {
        VStack(spacing: 0) {
            // Título
            Text("Crear Grupo")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            
            ScrollView {
                VStack(spacing: 20) {
                    campoDiseñado(titulo: "Nombre del grupo", texto: $nombreGrupo)
                    campoDiseñado(titulo: "Descripción (opcional)", texto: $descripcionGrupo)

                    // Imagen
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Imagen del Grupo")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        if let imagen = imagenSeleccionada {
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

                    // Botón Guardar
                    Button(action: {
                        print("Grupo creado: \(nombreGrupo)")
                        // lógica para guardar grupo
                    }) {
                        Text("Guardar Grupo")
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
            ImagePicker(image: $imagenSeleccionada)
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

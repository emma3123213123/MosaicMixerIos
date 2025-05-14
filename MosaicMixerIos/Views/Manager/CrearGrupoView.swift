import SwiftUI

struct CrearGrupoView: View {
    @State private var nombreGrupo: String = ""
    @State private var descripcionGrupo: String = ""
    @State private var imagenSeleccionada: UIImage?
    @State private var mostrarPicker = false
    @State private var mostrandoAlerta = false
    @State private var mensajeAlerta = ""
    @State private var esExito = false
    @State private var cargando = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Crear Grupo")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.white)

            ScrollView {
                VStack(spacing: 20) {
                    
                    if cargando {
                        Text("Subiendo grupo...")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    campoDiseñado(titulo: "Nombre del grupo", texto: $nombreGrupo)
                    campoDiseñado(titulo: "Descripción (opcional)", texto: $descripcionGrupo)

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

                    Button(action: guardarGrupo) {
                        Text("Guardar Grupo")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(cargando)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $mostrarPicker) {
            ImagePicker(image: $imagenSeleccionada)
        }
        .alert(isPresented: $mostrandoAlerta) {
            Alert(title: Text(esExito ? "Éxito" : "Error"),
                  message: Text(mensajeAlerta),
                  dismissButton: .default(Text("OK")))
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
                .foregroundColor(.black) // ✅ Texto en negro
        }
        .padding(.horizontal)
    }

    func guardarGrupo() {
        guard !nombreGrupo.isEmpty else {
            mostrarError("El nombre del grupo es obligatorio.")
            return
        }

        guard let imagen = imagenSeleccionada else {
            mostrarError("Debes seleccionar una imagen.")
            return
        }

        cargando = true

        GrupoManager.shared.guardarGrupo(nombre: nombreGrupo, descripcion: descripcionGrupo, imagen: imagen) { resultado in
            DispatchQueue.main.async {
                cargando = false
                switch resultado {
                case .success:
                    esExito = true
                    mensajeAlerta = "Grupo guardado exitosamente."
                    limpiarCampos()
                case .failure(let error):
                    mostrarError("Error al guardar grupo: \(error.localizedDescription)")
                }
                mostrandoAlerta = true
            }
        }
    }

    func mostrarError(_ mensaje: String) {
        esExito = false
        mensajeAlerta = mensaje
        mostrandoAlerta = true
    }

    func limpiarCampos() {
        nombreGrupo = ""
        descripcionGrupo = ""
        imagenSeleccionada = nil
    }
}

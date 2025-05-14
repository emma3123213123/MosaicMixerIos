import SwiftUI

struct EditarGrupoView: View {
    @Environment(\.dismiss) var dismiss
    @State var grupo: Grupo
    @State private var nuevoNombre: String
    @State private var nuevaDescripcion: String
    @State private var nuevaImagen: UIImage?
    @State private var mostrarPicker = false
    @State private var mostrandoAlerta = false
    @State private var mensajeAlerta = ""
    @State private var cargando = false
    var onGuardar: (() -> Void)? = nil

    init(grupo: Grupo) {
        _grupo = State(initialValue: grupo)
        _nuevoNombre = State(initialValue: grupo.nombre)
        _nuevaDescripcion = State(initialValue: grupo.descripcion)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Editar Grupo")
                    .font(.title2.bold())
                    .padding(.top)

                if cargando {
                    ProgressView("Actualizando...")
                }

                campoDiseñado(titulo: "Nombre", texto: $nuevoNombre)
                campoDiseñado(titulo: "Descripción", texto: $nuevaDescripcion)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Imagen actual")
                        .font(.subheadline)

                    if let imagen = nuevaImagen {
                        Image(uiImage: imagen)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .cornerRadius(12)
                    } else {
                        AsyncImage(url: URL(string: grupo.imagenURL)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .overlay(Text("Cargando imagen..."))
                        }
                        .frame(height: 180)
                        .cornerRadius(12)
                    }

                    Button("Cambiar Imagen") {
                        mostrarPicker = true
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal)

                Button("Guardar Cambios") {
                    guardarCambios()
                }
                .disabled(cargando)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Cerrar") {
                dismiss()
            })
        }
        .sheet(isPresented: $mostrarPicker) {
            ImagePicker(image: $nuevaImagen)
        }
        .alert(isPresented: $mostrandoAlerta) {
            Alert(title: Text("Aviso"),
                  message: Text(mensajeAlerta),
                  dismissButton: .default(Text("OK")))
        }
    }

    @ViewBuilder
    func campoDiseñado(titulo: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.subheadline)
                .foregroundColor(.red)
            TextField(titulo, text: texto)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        
    }

    func guardarCambios() {
        guard !nuevoNombre.isEmpty else {
            mensajeAlerta = "El nombre no puede estar vacío."
            mostrandoAlerta = true
            return
        }

        cargando = true

        GrupoManager.shared.editarGrupo(grupo: grupo, nuevoNombre: nuevoNombre, nuevaDescripcion: nuevaDescripcion, nuevaImagen: nuevaImagen) { resultado in
            DispatchQueue.main.async {
                cargando = false
                switch resultado {
                case .success:
                    mensajeAlerta = "Grupo actualizado correctamente."
                    onGuardar?() // Llamamos al callback
                    dismiss()
                case .failure(let error):
                    mensajeAlerta = "Error: \(error.localizedDescription)"
                    mostrandoAlerta = true
                }
            }
        }
    }
}

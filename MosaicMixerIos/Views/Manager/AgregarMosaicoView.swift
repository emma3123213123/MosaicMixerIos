import SwiftUI
import UniformTypeIdentifiers

struct AgregarMosaicoView: View {
    @State private var nombre: String = ""
    @State private var descripcion1: String = ""
    @State private var descripcion2: String = ""
    @State private var precio: String = ""
    
    @State private var imagen: UIImage?
    @State private var archivoUSDZ: URL?
    
    @State private var mostrarPickerImagen = false
    @State private var mostrarPickerArchivo = false

    @State private var grupoSeleccionado: String = ""
    let gruposDisponibles = ["Grupo A", "Grupo B", "Grupo C"]

    var body: some View {
        VStack(spacing: 0) {
            // Título
            Text("Agregar Mosaico")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            
            ScrollView {
                VStack(spacing: 20) {
                    Group {
                        campoDiseñado(titulo: "Nombre del mosaico", texto: $nombre)
                        campoDiseñado(titulo: "Descripción 1", texto: $descripcion1)
                        campoDiseñado(titulo: "Descripción 2", texto: $descripcion2)
                        campoDiseñado(titulo: "Precio", texto: $precio, teclado: .decimalPad)
                    }

                    // Picker de grupo
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Grupo")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        Menu {
                            ForEach(gruposDisponibles, id: \.self) { grupo in
                                Button(grupo) {
                                    grupoSeleccionado = grupo
                                }
                            }
                        } label: {
                            HStack {
                                Text(grupoSeleccionado.isEmpty ? "Seleccionar grupo" : grupoSeleccionado)
                                    .foregroundColor(grupoSeleccionado.isEmpty ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // Imagen
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Imagen del Mosaico")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        if let imagen = imagen {
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

                        Button(action: { mostrarPickerImagen = true }) {
                            Text("Seleccionar Imagen")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // Archivo USDZ
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Archivo USDZ (opcional)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 50)
                            .overlay(
                                HStack {
                                    Text(archivoUSDZ?.lastPathComponent ?? "Ningún archivo seleccionado")
                                        .foregroundColor(archivoUSDZ == nil ? .gray : .blue)
                                        .font(.footnote)
                                    Spacer()
                                    Image(systemName: "doc.badge.plus")
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                            )

                        Button(action: { mostrarPickerArchivo = true }) {
                            Text("Subir archivo USDZ")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // Botón Guardar
                    Button(action: {
                        print("Guardar mosaico: \(nombre)")
                        // lógica de subida
                    }) {
                        Text("Guardar Mosaico")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 90) // ¡Más espacio para evitar solapamiento!
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $mostrarPickerImagen) {
            ImagePicker(image: $imagen)
        }
        .fileImporter(
            isPresented: $mostrarPickerArchivo,
            allowedContentTypes: [.usdz],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                archivoUSDZ = urls.first
            case .failure(let error):
                print("Error al importar USDZ: \(error)")
            }
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    func campoDiseñado(titulo: String, texto: Binding<String>, teclado: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField(titulo, text: texto)
                .keyboardType(teclado)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

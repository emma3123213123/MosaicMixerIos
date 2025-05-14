import SwiftUI
import FirebaseFirestore

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
    @State private var gruposDisponibles: [String] = []

    @State private var cargando = false
    @State private var alerta: Alerta?
    @State private var mensajeCarga: String?

    func cargarGrupos() {
        let db = Firestore.firestore()
        db.collection("grupos").getDocuments { snapshot, error in
            if let error = error {
                print("Error al obtener los grupos: \(error.localizedDescription)")
            } else {
                self.gruposDisponibles = snapshot?.documents.compactMap { document in
                    return document["nombre"] as? String
                } ?? []
            }
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
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

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Grupo")
                                .font(.subheadline)
                                .foregroundColor(.black)

                            if gruposDisponibles.isEmpty {
                                Text("Cargando grupos...")
                                    .foregroundColor(.gray)
                            } else {
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
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Imagen del Mosaico")
                                .font(.subheadline)
                                .foregroundColor(.black)

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

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Archivo USDZ (opcional)")
                                .font(.subheadline)
                                .foregroundColor(.black)

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

                        Button(action: guardarMosaico) {
                            Text("Guardar Mosaico")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 90)
                    }
                    .padding(.top)
                }
            }

            // Capa de carga encima del contenido
            if cargando {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    ProgressView()
                    Text(mensajeCarga ?? "Subiendo mosaico…")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(15)
            }
        }
        .onAppear {
            cargarGrupos()
        }
        .sheet(isPresented: $mostrarPickerImagen) {
            ImagePicker(image: $imagen)
        }
        .sheet(isPresented: $mostrarPickerArchivo) {
            USDZDocumentPicker { url in
                archivoUSDZ = url
                print("✅ Archivo USDZ seleccionado: \(url)")
            }
        }
        .alert(item: $alerta) { alerta in
            Alert(title: Text(alerta.mensaje))
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    func campoDiseñado(titulo: String, texto: Binding<String>, teclado: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.subheadline)
                .foregroundColor(.black)
            TextField(titulo, text: texto)
                .keyboardType(teclado)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.black)
        }
        .padding(.horizontal)
    }

    func guardarMosaico() {
        guard !cargando else { return }
        cargando = true
        mensajeCarga = "Subiendo mosaico…"

        MosaicoManagerCharge.shared.guardarMosaico(
            nombre: nombre,
            descripcion1: descripcion1,
            descripcion2: descripcion2,
            precio: precio,
            grupo: grupoSeleccionado,
            imagen: imagen ?? UIImage(),
            archivoUSDZ: archivoUSDZ
        ) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                cargando = false
                switch result {
                case .success:
                    alerta = Alerta(mensaje: "✅ Mosaico guardado exitosamente")

                    // Limpiar campos
                    nombre = ""
                    descripcion1 = ""
                    descripcion2 = ""
                    precio = ""
                    imagen = nil
                    archivoUSDZ = nil
                    grupoSeleccionado = ""
                case .failure(let error):
                    alerta = Alerta(mensaje: "❌ Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct Alerta: Identifiable {
    var id = UUID()
    var mensaje: String
}

import SwiftUI

struct EditarMosaicoView: View {
    var mosaico: MosaicoCharge

    @State private var nombre: String
    @State private var descripcion1: String
    @State private var descripcion2: String
    @State private var precio: String
    @State private var grupo: String
    @State private var imagen: UIImage?
    @State private var archivoUSDZ: URL?

    @State private var mostrandoPickerImagen = false
    @State private var mostrandoPickerArchivo = false
    @State private var cargando = false
    @State private var alerta: Alerta?

    init(mosaico: MosaicoCharge) {
        self.mosaico = mosaico
        _nombre = State(initialValue: mosaico.nombre)
        _descripcion1 = State(initialValue: mosaico.descripcion1)
        _descripcion2 = State(initialValue: mosaico.descripcion2)
        _precio = State(initialValue: String(format: "%.2f", mosaico.precio))
        _grupo = State(initialValue: mosaico.grupo)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Editar Mosaico")
                    .font(.title2.bold())

                campoDiseñado(titulo: "Nombre", texto: $nombre)
                campoDiseñado(titulo: "Descripción 1", texto: $descripcion1)
                campoDiseñado(titulo: "Descripción 2", texto: $descripcion2)
                campoDiseñado(titulo: "Precio", texto: $precio, teclado: .decimalPad)

                campoDiseñado(titulo: "Grupo", texto: $grupo)

                Button("Seleccionar Imagen") {
                    mostrandoPickerImagen = true
                }
                if let imagen = imagen {
                    Image(uiImage: imagen)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }

                Button("Seleccionar archivo USDZ") {
                    mostrandoPickerArchivo = true
                }
                if let archivoUSDZ = archivoUSDZ {
                    Text("Archivo: \(archivoUSDZ.lastPathComponent)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Button("Actualizar Mosaico") {
                    actualizarMosaico()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $mostrandoPickerImagen) {
            ImagePicker(image: $imagen)
        }
        .sheet(isPresented: $mostrandoPickerArchivo) {
            USDZDocumentPicker { url in
                archivoUSDZ = url
            }
        }
        .alert(item: $alerta) { alerta in
            Alert(title: Text(alerta.mensaje))
        }
    }

    @ViewBuilder
    func campoDiseñado(titulo: String, texto: Binding<String>, teclado: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading) {
            Text(titulo)
                .font(.subheadline)
                .foregroundColor(.black)
            TextField(titulo, text: texto)
                .keyboardType(teclado)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }

    func actualizarMosaico() {
        guard let id = mosaico.id else { return }
        cargando = true

        MosaicoManagerCharge.shared.actualizarMosaico(
            id: id,
            nombre: nombre,
            descripcion1: descripcion1,
            descripcion2: descripcion2,
            precio: precio,
            grupo: grupo,
            imagen: imagen,
            archivoUSDZ: archivoUSDZ
        ) { result in
            cargando = false
            switch result {
            case .success:
                alerta = Alerta(mensaje: "✅ Mosaico actualizado")
            case .failure(let error):
                alerta = Alerta(mensaje: "❌ Error: \(error.localizedDescription)")
            }
        }
    }
}

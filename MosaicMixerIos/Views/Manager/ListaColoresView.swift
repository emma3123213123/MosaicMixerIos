import SwiftUI
import FirebaseFirestore

struct ListaColoresView: View {
    @State private var colores: [ColorPiedra] = []
    @State private var mostrarEditar: Bool = false
    @State private var colorSeleccionado: ColorPiedra?
    @State private var mostrandoAlerta = false
    @State private var estaCargando = true

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                Text("Mis Colores")
                    .font(.title.bold())
                    .foregroundColor(.black)
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .center)

                if estaCargando {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Cargando colores...")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    .padding(.top, 50)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(colores) { color in
                                VStack(alignment: .leading, spacing: 12) {
                                    AsyncImage(url: URL(string: color.imagenURL)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(height: 160)
                                    .cornerRadius(12)

                                    Text("Nombre: \(color.nombre)")
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    Text("Precio: \(color.precio)")
                                        .foregroundColor(.gray)

                                    HStack {
                                        Button(action: {
                                            colorSeleccionado = color
                                            mostrarEditar = true
                                        }) {
                                            HStack {
                                                Image(systemName: "pencil")
                                                Text("Editar")
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 6)
                                            .background(Color.orange.opacity(0.2))
                                            .cornerRadius(8)
                                        }

                                        Button(action: {
                                            eliminarColor(color)
                                        }) {
                                            HStack {
                                                Image(systemName: "trash")
                                                Text("Eliminar")
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 6)
                                            .background(Color.red.opacity(0.2))
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding()
                    }
                }
            }
            .sheet(item: $colorSeleccionado) { color in
                EditarColorView(color: color)
            }
            .alert(isPresented: $mostrandoAlerta) {
                Alert(
                    title: Text("Error"),
                    message: Text("Hubo un problema al eliminar el color."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            cargarColores()
        }
    }

    func cargarColores() {
        estaCargando = true
        let db = Firestore.firestore()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // pequeño delay para inicializar Firebase bien
            db.collection("colores").getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    self.colores = documents.compactMap { doc in
                        try? doc.data(as: ColorPiedra.self)
                    }
                }
                self.estaCargando = false
            }
        }
    }

    func eliminarColor(_ color: ColorPiedra) {
        guard let id = color.id else { return }

        let db = Firestore.firestore()
        db.collection("colores").document(id).delete { error in
            if let error = error {
                print("Error al eliminar: \(error)")
                mostrandoAlerta = true
            } else {
                cargarColores()
            }
        }
    }
}

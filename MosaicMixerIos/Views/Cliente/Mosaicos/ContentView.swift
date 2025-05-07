import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""

    let todosLosGrupos: [(String, [Mosaico])] = [
        ("Grupo 1", grupo1),
        ("Grupo 2", grupo2),
        ("Grupo 3", grupo3),
        ("Mcgaha", mcgaha),
        ("Artisan", artisan),
        ("Parquet", parquet),
        ("Pebbles", pebbles),
        ("Specialty", specialty)
    ]

    var gruposFiltrados: [(String, [Mosaico])] {
        if searchText.isEmpty {
            return todosLosGrupos
        } else {
            return todosLosGrupos.compactMap { (nombre, mosaicos) in
                let mosaicosFiltrados = mosaicos.filter {
                    $0.nombre.localizedCaseInsensitiveContains(searchText)
                }
                if nombre.localizedCaseInsensitiveContains(searchText) || !mosaicosFiltrados.isEmpty {
                    return (nombre, mosaicosFiltrados)
                } else {
                    return nil
                }
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 🔍 Barra de búsqueda
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("", text: $searchText)
                        .foregroundColor(.black)
                        .placeholder(when: searchText.isEmpty) {
                            Text("Buscar mosaico o grupo...")
                                .foregroundColor(.gray)
                        }
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding(.horizontal)
                .padding(.top, 20)

                // 📛 Título
                Text("Grupos")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)

                // 📜 Lista de grupos
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(gruposFiltrados, id: \.0) { nombre, mosaicos in
                            GrupoSectionView(nombre: nombre, mosaicos: mosaicos)
                        }
                    }
                    .padding(.bottom, 30)
                    .padding(.horizontal)
                }
            }
            .background(Color.white.ignoresSafeArea())
        }
    }
}

// 🔧 Placeholder para TextField
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

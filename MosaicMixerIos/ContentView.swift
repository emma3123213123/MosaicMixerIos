import SwiftUI

struct ContentView: View {
    @StateObject var favoritosManager = FavoritosManager() // 🔑 Creamos el manager UNA SOLA VEZ

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    Text("Search")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
                .background(Color(hex: "#eeeeee"))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 65)

                // Título
                Text("Grupos")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)

                // Lista de grupos
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        GrupoSectionView(nombre: "Grupo 1", mosaicos: grupo1)
                        GrupoSectionView(nombre: "Grupo 2", mosaicos: grupo2)
                        GrupoSectionView(nombre: "Grupo 3", mosaicos: grupo3)
                    }
                    .padding(.bottom, 70)
                }

                // Bottom Navigation Bar
                HStack {
                    Spacer()
                    Image(systemName: "cart")
                    Spacer()
                    NavigationLink(destination: FavoritosView()) {
                    Image(systemName: "heart")
                    };                    Spacer()
                    Image(systemName: "house")
                    Spacer()
                    Image(systemName: "bell")
                    Spacer()
                    Image(systemName: "person")
                    Spacer()
                }
                .foregroundColor(.white)
                .font(.system(size: 25))
                .padding(25)
                .background(Color.black)
            }
            .background(Color.white)
            .ignoresSafeArea(edges: .bottom)
        }
        .environmentObject(favoritosManager) // 🔁 Hacemos disponible el manager para TODA la app
    }
}

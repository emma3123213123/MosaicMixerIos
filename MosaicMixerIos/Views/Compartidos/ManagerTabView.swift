import SwiftUI

enum ManagerTab {
    case home, agregar, grupos, pedidos, perfil
}

struct ManagerMainTabView: View {
    @State private var selectedTab: ManagerTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            
            PedidosManagerView()
                .tag(ManagerTab.home)
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }

            AgregarMosaicoView()
                .tag(ManagerTab.agregar)
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("Agregar")
                }

            CrearGrupoView()
                .tag(ManagerTab.grupos)
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Grupos")
                }

            AgregarColorView()
                .tag(ManagerTab.pedidos)
                .tabItem {
                    Image(systemName: "paintpalette")
                    Text("Colores")
                }

            ManagerDashboardView()
                .tag(ManagerTab.perfil)
                .tabItem {
                    Image(systemName: "person")
                    Text("Perfil")
                }
        }
        .accentColor(.blue) // Colorea el ícono activo
        .navigationBarBackButtonHidden(true) // 

    }
    
}

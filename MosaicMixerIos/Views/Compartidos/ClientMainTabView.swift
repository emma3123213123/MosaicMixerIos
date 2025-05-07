//
//  ClientMainTabView.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 05/05/25.
//

import SwiftUI

enum ClientTab {
    case home, carrito, favoritos, notificaciones, perfil
}

struct ClientMainTabView: View {
    @State private var selectedTab: ClientTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tag(ClientTab.home)
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }

            CarritoView()
                .tag(ClientTab.carrito)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Carrito")
                }

            FavoritosView()
                .tag(ClientTab.favoritos)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favoritos")
                }

            NotificationView()
                .tag(ClientTab.notificaciones)
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notificaciones")
                }

            ProfileView()
                .tag(ClientTab.perfil)
                .tabItem {
                    Image(systemName: "person")
                    Text("Usuario")
                }
        }
        .accentColor(.blue)
        .navigationBarBackButtonHidden(true)
    }
}


// ManagerHomeLauncherView.swift
import SwiftUI

struct ManagerHomeLauncherView: View {
    var body: some View {
        ManagerTabView()
            .environmentObject(PedidoManager()) // Aquí colocas los objects necesarios
    }
}

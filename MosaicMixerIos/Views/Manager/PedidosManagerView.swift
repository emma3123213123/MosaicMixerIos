import SwiftUI

struct PedidosManagerView: View {
    @EnvironmentObject var pedidoManager: PedidoManager

    var body: some View {
        VStack(spacing: 0) {
            
            // TÍTULO ENCABEZADO
            HStack {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("Pedidos Recientes")
                    .font(.title2.bold())
                    .foregroundColor(.black)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)

            // RESUMEN VISUAL DE ESTADÍSTICAS
            HStack(spacing: 16) {
                PedidoSummaryBox(title: "Total", count: pedidoManager.pedidos.count, color: .blue)
                PedidoSummaryBox(title: "Pendientes", count: pedidoManager.pedidos.filter { $0.estado.lowercased() == "pendiente" }.count, color: .orange)
                PedidoSummaryBox(title: "Entregados", count: pedidoManager.pedidos.filter { $0.estado.lowercased() == "entregado" }.count, color: .green)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)

            // LISTADO DE PEDIDOS RECIENTES
            ScrollView {
                if pedidoManager.pedidos.isEmpty {
                    VStack {
                        Spacer()
                        Text("No hay pedidos recientes.")
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    }
                } else {
                    VStack(spacing: 12) {
                        ForEach(pedidoManager.pedidos) { pedido in
                            PedidoCard(pedido: pedido)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }

           
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct PedidoSummaryBox: View {
    let title: String
    let count: Int
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

//
//  ListaMosaicosView.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 12/05/25.
//

import SwiftUI

struct ListaMosaicosView: View {
    @StateObject var viewModel = MosaicoListViewModel()
    @State private var mosaicoSeleccionado: MosaicoCharge?
    @State private var mostrarEditor = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.mosaicos) { mosaico in
                    VStack(alignment: .leading) {
                        Text(mosaico.nombre).font(.headline)
                        Text("Grupo: \(mosaico.grupo)").font(.subheadline)
                        
                        if let precioDouble = Double(mosaico.precio) {
                            Text("$\(precioDouble, specifier: "%.2f")").font(.subheadline)
                        } else {
                            Text("Precio inválido").foregroundColor(.red).font(.subheadline)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mosaicoSeleccionado = mosaico
                        mostrarEditor = true
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let mosaico = viewModel.mosaicos[index]
                        viewModel.eliminarMosaico(mosaico)
                    }
                }
            }
            .navigationTitle("Mosaicos")
            .onAppear {
                viewModel.cargarMosaicos()
            }
            .sheet(isPresented: $mostrarEditor) {
                if let mosaico = mosaicoSeleccionado {
                    EditarMosaicoView(mosaico: mosaico)
                }
            }
        }
    }
}

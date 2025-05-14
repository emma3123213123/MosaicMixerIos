//
//  ListaGruposViews.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 11/05/25.
//

import SwiftUI
import Foundation
import FirebaseFirestore

struct ListaGruposView: View {
    @StateObject private var viewModel = GrupoListViewModel()
    @State private var grupoSeleccionado: Grupo?
    @State private var mostrarEditor = false
    @State private var mostrandoAlerta = false
    @State private var cargando = true

    var body: some View {
        VStack {
            Text("Mis Grupos")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()

            if cargando {
                ProgressView("Cargando grupos...")
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.grupos) { grupo in
                            VStack(alignment: .leading, spacing: 8) {
                                AsyncImage(url: URL(string: grupo.imagenURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(height: 160)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 160)
                                            .clipped()
                                            .cornerRadius(12)
                                    case .failure:
                                        Color.gray
                                            .frame(height: 160)
                                            .overlay(Text("Imagen no disponible").foregroundColor(.white))
                                            .cornerRadius(12)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }

                                Text("Nombre: \(grupo.nombre)")
                                    .font(.headline)
                                    .foregroundColor(.black)

                                if !grupo.descripcion.isEmpty {
                                    Text("Descripción: \(grupo.descripcion)")
                                        .foregroundColor(.gray)
                                }

                                HStack {
                                    Button(action: {
                                        grupoSeleccionado = grupo
                                        mostrarEditor = true
                                    }) {
                                        Label("Editar", systemImage: "pencil")
                                            .padding(8)
                                            .background(Color.orange.opacity(0.2))
                                            .cornerRadius(8)
                                    }

                                    Button(action: {
                                        eliminarGrupo(grupo)
                                    }) {
                                        Label("Eliminar", systemImage: "trash")
                                            .padding(8)
                                            .background(Color.red.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchGrupos {
                cargando = false
            }
        }
        .sheet(item: $grupoSeleccionado) { grupo in
            EditarGrupoView(grupo: grupo)
        }
        .alert(isPresented: $mostrandoAlerta) {
            Alert(
                title: Text("Error"),
                message: Text("No se pudo eliminar el grupo."),
                dismissButton: .default(Text("OK"))
            )
        }
        .background(Color(.systemGray6))
    }

    func eliminarGrupo(_ grupo: Grupo) {
        let db = Firestore.firestore()
        db.collection("grupos").document(grupo.id).delete { error in
            if let error = error {
                print("Error al eliminar grupo: \(error.localizedDescription)")
                mostrandoAlerta = true
            } else {
                // Elimina el grupo de la lista local también
                if let index = viewModel.grupos.firstIndex(where: { $0.id == grupo.id }) {
                    viewModel.grupos.remove(at: index)
                }
            }
        }
    }
}

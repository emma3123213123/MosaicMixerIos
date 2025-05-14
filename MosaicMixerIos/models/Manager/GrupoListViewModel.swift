//
//  GrupoListViewModels.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 11/05/25.
//


import FirebaseFirestore

class GrupoListViewModels: ObservableObject {
    @Published var grupos: [Grupo] = []
    
    private let db = Firestore.firestore()
    
    init() {
        fetchGrupos() // Llamamos a la función en el init sin parámetro
    }

    func fetchGrupos() {
        db.collection("grupos").addSnapshotListener { snapshot, error in
            guard let documentos = snapshot?.documents else { return }
            self.grupos = documentos.compactMap { doc in
                try? doc.data(as: Grupo.self)
            }
        }
    }
}


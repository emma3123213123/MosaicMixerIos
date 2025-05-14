//
//  ListaMosaicosViewModel.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 12/05/25.
//
import Foundation
import FirebaseFirestore

class MosaicoListViewModel: ObservableObject {
    @Published var mosaicos: [MosaicoCharge] = []

    private var db = Firestore.firestore()

    func cargarMosaicos() {
        db.collection("mosaicos").order(by: "fechaCreacion", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Error al cargar mosaicos: \(error.localizedDescription)")
                return
            }

            self.mosaicos = snapshot?.documents.compactMap { doc in
                try? doc.data(as: MosaicoCharge.self)
            } ?? []
        }
    }

    func eliminarMosaico(_ mosaico: MosaicoCharge) {
        guard let id = mosaico.id else { return }
        db.collection("mosaicos").document(id).delete { error in
            if let error = error {
                print("❌ Error al eliminar mosaico: \(error.localizedDescription)")
            }
        }
    }
}


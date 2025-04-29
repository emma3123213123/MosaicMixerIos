//
//  DynamicARViewContainer.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 28/04/25.
//

import SwiftUI
import RealityKit
import ARKit

struct DynamicARViewContainer: UIViewRepresentable {
    var selectedColors: [ColorInfo]
    var modelName: String

    
    
    
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar)

        // Retrasar ligeramente el inicio de la sesión para evitar pantalla negra
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            configuration.environmentTexturing = .automatic

            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }

        loadModel(into: arView, modelName: "78MOSAIC6", selectedColors: selectedColors)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Si necesitas hacer updates dinámicos aquí, puedes agregarlos luego
    }
}
func loadModel(into arView: ARView, modelName: String, selectedColors: [ColorInfo]) {
    do {
        let modelEntity = try Entity.loadModel(named: modelName)
        modelEntity.scale = SIMD3<Float>(1.3, 1.5, 1.4)

        let sequences = MaterialSequences.sequences(forModel: "78MOSAIC6")
        var materials = modelEntity.model?.materials ?? []

        for (index, colorInfo) in selectedColors.enumerated() {
            guard index < sequences.count else { continue }
            let sequence = sequences[index]

            if let texture = try? TextureResource.load(named: colorInfo.imageName) {
                var material = UnlitMaterial()
                material.baseColor = .texture(texture)

                for materialIndex in sequence {
                    if materialIndex < materials.count {
                        materials[materialIndex] = material
                    }
                }
            }
        }

        if selectedColors.isEmpty {
            var blackMaterial = UnlitMaterial()
            blackMaterial.baseColor = .color(.black)
            for i in materials.indices {
                materials[i] = blackMaterial
            }
        }

        modelEntity.model?.materials = materials

        let anchor = AnchorEntity()
        anchor.addChild(modelEntity)
        arView.scene.anchors.append(anchor)

    } catch {
        print("❌ Error cargando modelo: \(error.localizedDescription)")
    }
}

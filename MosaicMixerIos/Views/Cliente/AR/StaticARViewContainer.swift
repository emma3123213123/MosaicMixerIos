//
//  StaticARViewContainer.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 28/04/25.
//
//
//  StaticARViewContainer.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 28/04/25.
//

import SwiftUI
import RealityKit
import ARKit

    // ARViewContainer
    struct StaticARViewContainer: UIViewRepresentable {
        var selectedColors: [ColorInfo] // Colores seleccionados
        var modelName: String           // Nombre del modelo 3D
        var isStatic: Bool              // Indica si el modelo debe estar estático o dinámico

        func makeUIView(context: Context) -> ARView {
            return createARView()
        }

        private func createARView() -> ARView {
            let arView = ARView(frame: .zero)

            if isStatic {
                // Fondo blanco para modo estático
                arView.environment.background = .color(.white)
                arView.cameraMode = .nonAR
                

            } else {
                arView.cameraMode = .ar // ✅ Primero establece el modo

                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = [.horizontal]
                arView.session.run(configuration) // ✅ Luego inicia la sesión
            }

            do {
                let modelEntity = try Entity.loadModel(named: modelName)
                modelEntity.scale = SIMD3<Float>(1.3, 1.5, 1.4)

                // Configura los materiales del modelo
                let sequences = MaterialSequences.sequences(forModel: modelName)
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

                // Si no hay colores, pintar de negro
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

            return arView
        }

        func updateUIView(_ uiView: ARView, context: Context) {
            // Aquí puedes manejar actualizaciones dinámicas si es necesario
        }
    }







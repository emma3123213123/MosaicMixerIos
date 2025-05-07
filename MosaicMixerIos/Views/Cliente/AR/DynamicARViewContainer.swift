import SwiftUI
import RealityKit
import ARKit

struct DynamicARViewContainer: UIViewRepresentable {
    var selectedColors: [ColorInfo]
    var modelName: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar)
        
        // Configuración AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
        
        // Carga el modelo y aplica texturas
        loadModel(into: arView, modelName: modelName, selectedColors: selectedColors, coordinator: context.coordinator)
        
        // Gestos de arrastrar manualmente (pan)
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(_:)))
        context.coordinator.arView = arView
        arView.addGestureRecognizer(panGesture)
    
        NotificationCenter.default.addObserver(forName: NSNotification.Name("DuplicateModel"), object: nil, queue: .main) { _ in
                  context.coordinator.duplicateModel()
              }
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Si necesitas actualizar algo dinámicamente, lo puedes hacer aquí
    }

    // MARK: - Coordinator

    class Coordinator: NSObject {
        weak var arView: ARView?
        var modelEntity: Entity?

        func duplicateModel() {
             guard let model = modelEntity?.clone(recursive: true),
                   let arView = arView else { return }

             model.generateCollisionShapes(recursive: true)
            arView.installGestures([.rotation, .scale, .translation], for: model as! HasCollision)

             let anchor = AnchorEntity(world: [0, 0, -0.2])
             anchor.addChild(model)
             arView.scene.anchors.append(anchor)
         }
     
 
        
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let arView = arView else { return }

            let location = gesture.location(in: arView)
            let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)

            if let result = results.first, let model = modelEntity {
                let transform = Transform(matrix: result.worldTransform)
                model.move(to: transform, relativeTo: nil, duration: 0.1)
            }
        }
    }
}


func loadModel(into arView: ARView, modelName: String, selectedColors: [ColorInfo], coordinator: DynamicARViewContainer.Coordinator) {
    do {
        let modelEntity = try Entity.loadModel(named:  modelName)
        modelEntity.scale = SIMD3<Float>(1.3, 1.5, 1.4)

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

        if selectedColors.isEmpty {
            var blackMaterial = UnlitMaterial()
            blackMaterial.baseColor = .color(.black)
            for i in materials.indices {
                materials[i] = blackMaterial
            }
        }

        modelEntity.model?.materials = materials

        // Añadir colisión
        modelEntity.generateCollisionShapes(recursive: true)

        // Gestos incorporados (rotar, escalar, mover)
        arView.installGestures([.translation, .rotation, .scale], for: modelEntity)

        // Anchor
        let anchor = AnchorEntity(world: [0, 0, -0.1]) // medio metro al frente
        anchor.addChild(modelEntity)
        arView.scene.anchors.append(anchor)

        // Referencia en el coordinator
        coordinator.modelEntity = modelEntity

    } catch {
        print("❌ Error cargando modelo: \(error.localizedDescription)")
    }
}


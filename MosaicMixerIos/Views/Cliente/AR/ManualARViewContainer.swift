import SwiftUI
import SceneKit

struct ManualARViewContainer: UIViewRepresentable {
    @Binding var currentColor: ColorInfo?
    let modelName: String  // Nombre del archivo .scn (sin la extensión)

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.allowsCameraControl = true
        scnView.backgroundColor = .white

        // Cargar el modelo .scn con ajustes
        loadSCNModel(named: modelName, in: scnView)

        // Habilitar interacciones
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)

        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        // Aquí podrías actualizar la vista si cambia currentColor
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(currentColor: $currentColor)
    }

    // MARK: - Carga del modelo con centrado y cámara
    private func loadSCNModel(named modelName: String, in scnView: SCNView) {
        guard let scene = try? SCNScene(named: "\(modelName).scn") else {
            print("❌ No se pudo cargar el modelo \(modelName).scn")
            return
        }

        scnView.scene = scene

        // Buscar el primer nodo con geometría
        guard let node = scene.rootNode.childNodes.first(where: { $0.geometry != nil }) else {
            print("⚠️ No se encontró nodo con geometría")
            return
        }

        // Centrar el modelo con bounding box
        let (min, max) = node.boundingBox
        let center = SCNVector3(
            (min.x + max.x) / 2,
            (min.y + max.y) / 2,
            (min.z + max.z) / 2
        )
        node.position = SCNVector3(-center.x, -center.y, -center.z)
        node.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)

        // Ajustar escala si es necesario (opcional)
        let size = max.x - min.x
        if size > 10 {
            node.scale = SCNVector3(0.1, 0.1, 0.1)
        }

        // Crear y asignar cámara
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, size * 2)
        scene.rootNode.addChildNode(cameraNode)
        scnView.pointOfView = cameraNode
    }

    // MARK: - Coordinador para manejar los toques
    class Coordinator: NSObject {
        @Binding var currentColor: ColorInfo?

        init(currentColor: Binding<ColorInfo?>) {
            _currentColor = currentColor
        }
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let scnView = gesture.view as? SCNView else { return }
            let location = gesture.location(in: scnView)
            let hitResults = scnView.hitTest(location, options: nil)

            guard let result = hitResults.first else { return }

            let geometryIndex = result.geometryIndex
            if let geometry = result.node.geometry {
                let materials = geometry.materials
                if geometryIndex < materials.count, let color = currentColor {
                    let touchedMaterial = materials[geometryIndex]
                    
                    // Verifica si la imagen existe
                    if let textureImage = UIImage(named: color.imageName) {
                        let newMaterial = SCNMaterial()
                        newMaterial.diffuse.contents = color.imageName  // Cambia el color a rojo
                        newMaterial.diffuse.wrapS = .repeat
                        newMaterial.diffuse.wrapT = .repeat
                        
                        result.node.geometry?.materials[geometryIndex] = newMaterial
                        print("🎨 Pintando material en index \(geometryIndex) con imagen: \(color.imageName)")
                    } else {
                        print("❌ Imagen no encontrada: \(color.imageName)")
                    }
                } else {
                    print("⚠️ No hay color disponible o índice de material no válido")
                }
            }
        }

        
       
    }
}

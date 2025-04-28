import SwiftUI
import RealityKit
import ARKit

struct ManualARViewContainer: UIViewRepresentable {
    @Binding var currentColor: ColorInfo?
    var modelName: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.environment.background = .color(.white)
        
        context.coordinator.arView = arView
        loadModel(in: arView)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Nada por ahora, el update lo manejamos solo con los taps
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(currentColor: $currentColor, modelName: modelName)
    }
    
    private func loadModel(in arView: ARView) {
        do {
            let modelEntity = try Entity.loadModel(named: "78MOSAIC6")
            modelEntity.name = "mosaicModel"
            modelEntity.scale = SIMD3<Float>(1.3, 1.5, 1.4)
            
            modelEntity.generateCollisionShapes(recursive: true)
            arView.debugOptions.insert(.showPhysics)
            
            let anchor = AnchorEntity(world: SIMD3<Float>(0, 0, -0.5))
            anchor.addChild(modelEntity)
            arView.scene.anchors.append(anchor)
            
            print("✅ Modelo cargado correctamente y anclado.")
            
        } catch {
            print("❌ Error al cargar modelo: \(error.localizedDescription)")
        }
    }
    
    class Coordinator: NSObject {
        var arView: ARView?
        @Binding var currentColor: ColorInfo?
        var modelName: String
        
        init(currentColor: Binding<ColorInfo?>, modelName: String) {
            self._currentColor = currentColor
            self.modelName = modelName
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            print("📍 TAP detectado")
            
            guard let arView = arView else {
                print("❌ arView no disponible")
                return
            }
            
            guard let color = currentColor else {
                print("❌ currentColor está vacío")
                return
            }
            
            // Cargar la textura desde la imagen seleccionada en `color.imageName`
            guard let texture = try? TextureResource.load(named: color.imageName) else {
                print("❌ No se pudo cargar la textura: \(color.imageName)")
                return
            }
            
            let location = sender.location(in: arView)
            print("👉 Tap en pantalla en ubicación: \(location)")
            
            // Usar raycasting para detectar la parte del modelo tocada
            let ray = arView.ray(through: location)
            guard let rayOrigin = ray?.origin, let rayDirection = ray?.direction else {
                print("❌ Raycasting falló")
                return
            }
            
            // Realizar el raycast en la escena usando el origen y la dirección del rayo
            let results = arView.scene.raycast(origin: rayOrigin, direction: rayDirection)
            
            if let result = results.first {
                print("🎯 Se tocó la entidad: \(result.entity.name)")
                
                // Asegúrate de que la entidad tocada sea un ModelEntity
                if let modelEntity = result.entity as? ModelEntity {
                    print("🔧 El modelo tiene \(modelEntity.model?.materials.count ?? 0) materiales asignados.")
                    
                    // Iterar sobre los materiales de la entidad
                    for (index, material) in modelEntity.model!.materials.enumerated() {
                        print("🔨 Material \(index): \(material)")
                        
                        // Aplicar la textura solo al material tocado
                        var newMaterial = UnlitMaterial()
                        newMaterial.baseColor = .texture(texture)
                        modelEntity.model?.materials[index] = newMaterial
                        
                        // Mostrar el cambio
                        print("✅ Material \(index) actualizado con nueva textura.")
                    }
                }
            } else {
                print("❌ No se tocó ninguna entidad en la escena.")
            }
        }
    }
}

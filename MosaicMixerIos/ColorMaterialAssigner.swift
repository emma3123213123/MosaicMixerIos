//
//  ColorMaterialAssigner.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 27/04/25.
//

import RealityKit

class ColorMaterialAssigner {
    static func assignMaterials(to modelEntity: ModelEntity, with colors: [ColorInfo], modelName: String = "") {
        guard let modelMaterials = modelEntity.model?.materials else { return }

        let sequences = MaterialSequences.sequences(forModel: modelName)
        var newMaterials = modelMaterials

        for (index, color) in colors.enumerated() {
            guard index < sequences.count,
                  let texture = try? TextureResource.load(named: color.imageName) else { continue }

            var material = UnlitMaterial()
            material.baseColor = .texture(texture)

            for materialIndex in sequences[index] {
                if materialIndex < newMaterials.count {
                    newMaterials[materialIndex] = material
                }
            }
        }

        modelEntity.model?.materials = newMaterials
    }
}

//
//  SatelliteFactory.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 3/3/26.
//

import RealityKit
import SwiftUI

//TODO add stars + Earth texture (Use RC pro models to look cooler?)

struct SatelliteFactory {
    static func createSatelliteScene() -> [ModelEntity] {
         var returnArr : [ModelEntity] = []
        let stl = Satellite()
        stl.entity.position = [0, 0, -50]
        returnArr.append(stl.entity)
        
        //MARK: Reality Composer Pro test :)
        
        do {
            let earth = try Entity.load(named: "Earth")
            let models = extractModels(from: earth) //currently just contains earth
            
            for model in models { //If we add to scene change this and there's definitely a better way to do this (which is just a test)
                
                model.position = [0, -100, -200]
                model.scale = [975.6, 975.6, 975.6]
                returnArr.append(model)
            }
            
            returnArr.append(contentsOf: models)
        } catch {
            print("Failed to load earth")
        }
        
        return returnArr
    }
    
    
    static func extractModels(from entity: Entity) -> [ModelEntity] {
        var models: [ModelEntity] = []

        if let model = entity as? ModelEntity {
            models.append(model)
        }

        for child in entity.children {
            models.append(contentsOf: extractModels(from: child))
        }

        return models
    }
}




@available(iOS 18.0, *)
struct Satellite {
    var entity: ModelEntity
    
    init() {
        let ssBodyMesh = MeshResource.generateBox(width: 10, height: 20, depth: 10, cornerRadius: 5)
        let ssMaterial = SimpleMaterial(color: .white, roughness: 0, isMetallic: false)
        let ssEntity = ModelEntity(mesh: ssBodyMesh, materials: [ssMaterial])
        ssEntity.position = [0, 0, 0]
        
        let bubbleMesh = MeshResource.generateSphere(radius: 3)
        let bMaterial = SimpleMaterial(color: .cyan.withAlphaComponent(0.75), roughness: 0, isMetallic: false)
        let bubble = ModelEntity(mesh: bubbleMesh, materials: [bMaterial])
        bubble.position = [0, 0, 5]
        
        entity = ModelEntity()
        entity.addChild(ssEntity)
        entity.addChild(bubble)
        
        for i in 0..<2 {
        
            let wing = MeshResource.generateBox(width: 10, height: 5, depth: 1)
            let wMaterial = SimpleMaterial(color: .systemBrown, roughness: 0, isMetallic: false)
            let wEntity = ModelEntity(mesh: wing, materials: [wMaterial])
            wEntity.position = [i == 0 ? 10 : -10, 0, 0]
        
            entity.addChild(wEntity)
        
            self.rotateWings(wEntity)
        }
    }
    
    func rotateWings(_ ent: ModelEntity) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let rotationAngle: Float = (45 / 180.0) * .pi
            let rotationAxis = SIMD3<Float>(1, 0, 0)
            var transform : Transform = Transform()
            transform.rotation = simd_quatf(angle: rotationAngle, axis: rotationAxis)
            ent.move(to: transform, relativeTo: ent, duration: 0)
        })
    }
}

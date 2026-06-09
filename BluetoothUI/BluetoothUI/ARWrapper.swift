//
//  ARWrapper.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 3/4/26.
//

import Foundation
import RealityKit
import SwiftUI
import ARKit

//MARK: UIViewRepresentable example (can do more this way than with plain RealityView)

//Add MapView here

//SwiftUI parent -> UIView subclass
struct ARWrapperContainer: UIViewRepresentable {
    
    typealias UIViewType = ARWrapper
    
    func updateUIView(_ uiView: ARWrapper, context: Context) {
        if uiView.delegate == nil {
            uiView.delegate = context.coordinator
        }
    }
    
    func makeUIView(context: Context) -> ARWrapper {
        return ARWrapper(frame: .zero)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class ARWrapper: ARView {
    
    weak var delegate : ARDelegate?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect, cameraMode: .nonAR, automaticallyConfigureSession: true)
    }
    
    @MainActor @preconcurrency required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpScene() {
        
    }
}


//Pass data from child -> parent
protocol ARDelegate: NSObjectProtocol {
    func handleSomething()
}

class Coordinator: NSObject, ARDelegate {
    let parent: ARWrapperContainer //strong since parent is struct
    
    init(_ parent: ARWrapperContainer) {
        self.parent = parent
    }
    
    func handleSomething() {
        //Do something
    }
}

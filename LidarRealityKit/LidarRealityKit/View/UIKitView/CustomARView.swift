//
//  CustomARView.swift
//  LidarRealityKit
//
//  Created by Tri Dang on 10/05/2021.
//

import ARKit
import RealityKit
import SwiftUI

class CustomARView: ARView {
    required init(frame ARFrame: CGRect) {
        super.init(frame: .zero)
    }

    @objc dynamic required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.sceneReconstruction = .mesh
        config.environmentTexturing = .manual
        config.frameSemantics = [.sceneDepth, .smoothedSceneDepth]
        session.delegate = self
        session.run(config)
        // show grid
        self.debugOptions = .showSceneUnderstanding
        
    }
}

extension CustomARView: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        anchors.forEach { _ in
        }
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
    }
}

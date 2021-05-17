//
//  ARViewContainer.swift
//  LidarRealityKit
//
//  Created by Tri Dang on 10/05/2021.
//

import ARKit
import RealityKit
import SwiftUI
import UIKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var isSave: Bool
    @Binding var isPresent: Bool
    @Binding var url: URL?
    @Binding var isCapture: Bool

    var capturedImageTextureCache: CVMetalTextureCache!

    func makeUIView(context: Context) -> ARView {
        let arView = CustomARView(frame: .zero)
        arView.setup()
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if isSave == true {
            guard let frame = uiView.session.currentFrame else {
                fatalError("Couldn't get the current ARFrame")
            }

            // Fetch the default MTLDevice to initialize a MetalKit buffer allocator with
            guard let device = MTLCreateSystemDefaultDevice() else {
                fatalError("Failed to get the system's default Metal device!")
            }

            // Fetch all ARMeshAncors
            let meshAnchors = frame.anchors.compactMap({ $0 as? ARMeshAnchor })

            // Setting the path to export the OBJ file to
            let documentsPath = FileManager.default.urls(for: .documentDirectory,
                                                         in: .userDomainMask).first!
            let urlOBJ = documentsPath.appendingPathComponent("scan.obj")

            do {
                try meshAnchors.save(to: urlOBJ, device: device)
                DispatchQueue.main.async {
                    url = urlOBJ
                    isPresent = true
                    isSave = false
                }
            } catch let error {
                fatalError(error.localizedDescription)
            }
        }
    }
}

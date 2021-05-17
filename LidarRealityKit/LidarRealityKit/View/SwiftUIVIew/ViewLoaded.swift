//
//  ViewLoaded.swift
//  LidarRealityKit
//
//  Created by Tri Dang on 10/05/2021.
//

import ARKit
import SceneKit
import SwiftUI

struct ViewLoaded: View {
    @Binding var url: URL?
    @State var isPresent: Bool = false
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if let url = url {
                    let scene = try! SCNScene(url: url)
                    SceneView(scene: scene, options: [.allowsCameraControl, .autoenablesDefaultLighting, .jitteringEnabled, .temporalAntialiasingEnabled, .rendersContinuously])
                } else {
                    Text("no object scaned")
                }

                Button(action: {
                    isPresent = true
                }, label: {
                    Text("Completed and Share")
                })
            }
            SharedView(url: $url, isPresent: $isPresent)
                .frame(height: 1)
        }
    }
}

struct ViewLoaded_Previews: PreviewProvider {
    static var previews: some View {
        ViewLoaded(url: .constant(URL(string: "")))
    }
}

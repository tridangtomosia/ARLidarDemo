//
//  ScanARView.swift
//  LidarRealityKit
//
//  Created by Tri Dang on 10/05/2021.
//

import SwiftUI

struct ScanARView: View {
    @State var isSave: Bool = false
    @State var isPresent: Bool = false
    @State var url: URL?
    @Binding var isCaptureVideo: Bool?
    @State var isStar = false
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .bottom) {
                    ARViewContainer(isSave: $isSave,
                                    isPresent: $isPresent,
                                    url: $url,
                                    isCapture: $isStar)
                        .edgesIgnoringSafeArea(.all)
                    // name requite for save to movie to document.
                    RPKitcontroller(isRecord: $isCaptureVideo, name: "record")
                    HStack {
                        Button(action: {
                            var isStart = isCaptureVideo ?? false
                            isStart.toggle()
                            isCaptureVideo = isStart
                            isStar.toggle()
                        }, label: {
                            if isCaptureVideo == true {
                                Text("StopRecord")
                            } else {
                                Text("StarRecord")
                            }
                        })
                        Spacer()
                            .frame(width: 20)
                        Button(action: {
                            isSave.toggle()
                        }, label: {
                            Text("Checking Object")
                        })
                    }
                }

                NavigationLink(destination: ViewLoaded(url: $url),
                               isActive: self.$isPresent) { EmptyView() }
            }
        }
        .navigationBarHidden(true)
    }
}

// struct ScanARView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScanARView(isCapture: .constant(false))
//    }
// }

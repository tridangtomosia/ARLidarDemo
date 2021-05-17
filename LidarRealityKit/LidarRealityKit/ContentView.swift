//
//  ContentView.swift
//  LidarRealityKit
//
//  Created by apple on 5/4/21.
//

import SwiftUI

struct ContentView: View {
    @State var isHidden: Bool = false
    @State var isStarScan: Bool?
    var body: some View {
        NavigationView {
            HStack {
                ZStack(alignment: Alignment.topLeading) {
                    ScanARView(isCaptureVideo: $isStarScan)                }
            }
            .navigationBarHidden(true)
        }
    }
}

// class AVCaptureViewController: UIViewController {
//    var previewLayer = AVCaptureVideoPreviewLayer()
//    var videoDataOutput = AVCaptureMovieFileOutput()
//    var delegate: AVCaptureFileOutputRecordingDelegate?
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        auth()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    func auth() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            settingSession()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if granted {
//                    DispatchQueue.main.async {
//                        self.settingSession()
//                    }
//                } else {
//                    print("action no")
//                    return
//                }
//            }
//        case .restricted:
//            print("GotoSetting")
//        case .denied:
//            print("GotoSetting")
//        @unknown default:
//            print("GotoSetting")
//        }
//    }
//
//    private func settingSession() {
//        let captureSession = AVCaptureSession()
//
//        if let captureDevice = AVCaptureDevice.default(for: .video) {
//            do {
//                let input = try AVCaptureDeviceInput(device: captureDevice)
//                if captureSession.canAddInput(input) {
//                    captureSession.addInput(input)
//                }
//            } catch {
//                print("faillue to register")
//            }
//        }
//
//        if captureSession.canAddOutput(videoDataOutput) {
//            captureSession.addOutput(videoDataOutput)
//        }
//
//        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        cameraLayer.frame = view.frame
//        cameraLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(cameraLayer)
//        captureSession.startRunning()
//    }
// }
//
// struct RecordVideoViewcontroller: UIViewControllerRepresentable {
//    @Binding var isStop: Bool
//    let file = AVCaptureMovieFileOutput()
//    func makeUIViewController(context: Context) -> some AVCaptureViewController {
//        let viewController = AVCaptureViewController()
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        if isStop {
//            if uiViewController.videoDataOutput.isRecording {
//                print("stop")
//                uiViewController.videoDataOutput.stopRecording()
//            } else {
//                print("star")
//                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//                let fileUrl = paths[0].appendingPathComponent("moview.mp4")
//                try? FileManager.default.removeItem(at: fileUrl)
//                uiViewController.videoDataOutput.startRecording(to: fileUrl, recordingDelegate: context.coordinator)
//            }
//        }
//    }
//
//    func makeCoordinator() -> AVCaptureFileOutputRecordingDelegate {
//        return Cordinator(self)
//    }
//
//    class Cordinator: NSObject, AVCaptureFileOutputRecordingDelegate {
//        var view: RecordVideoViewcontroller
//        init(_ view: RecordVideoViewcontroller) {
//            self.view = view
//        }
//
//        func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//            PHPhotoLibrary.shared().performChanges({
//                let options = PHAssetResourceCreationOptions()
//                options.shouldMoveFile = true
//                let creationRequest = PHAssetCreationRequest.forAsset()
//                creationRequest.addResource(with: .video, fileURL: outputFileURL, options: options)
//            }, completionHandler: { success, error in
//                if !success {
//                    print("AVCam couldn't save the movie to your photo library: \(String(describing: error))")
//                }
//            }
//            )
//        }
//    }
// }

// #if DEBUG
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView()
//        }
//    }
// #endif

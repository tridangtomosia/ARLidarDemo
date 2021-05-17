//
//  RPKitVideo.swift
//  LidarRealityKit
//
//  Created by Tri Dang on 16/05/2021.
//

import AVKit
import ReplayKit
import SwiftUI

struct RPKitcontroller: UIViewControllerRepresentable {
    @Binding var isRecord: Bool?
    @State var name: String
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if isRecord == true {
            RPScreenRecorder.shared().startRecording { _ in }
        } else if isRecord == false {
            
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = fileUrls.appendingPathComponent("\(name).mp4")
            RPScreenRecorder.shared().stopRecording(withOutput: fileUrl) { _ in
            }
            // here can using url mp4 video
            let activityItem: [AnyObject] = [fileUrl as AnyObject]
            let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
            uiViewController.present(avc, animated: true)
            DispatchQueue.main.async {
                self.isRecord = nil
            }
        }
    }
}

class ScreenRecorder {
    var assetWriter: AVAssetWriter!
    var videoInput: AVAssetWriterInput!

    // MARK: Screen Recording

    func startRecording(withFileName fileName: String, recordingHandler: @escaping (Error?) -> Void) {
        if #available(iOS 11.0, *) {
            let fileURL = URL(fileURLWithPath: "movie")
            assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType:
                AVFileType.mp4)
            let videoOutputSettings: Dictionary<String, Any> = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: UIScreen.main.bounds.size.width,
                AVVideoHeightKey: UIScreen.main.bounds.size.height,
            ]

            videoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
            videoInput.expectsMediaDataInRealTime = true
            assetWriter.add(videoInput)

            RPScreenRecorder.shared().startCapture(handler: { sample, bufferType, error in
//                print(sample,bufferType,error)

                recordingHandler(error)

                if CMSampleBufferDataIsReady(sample) {
                    if self.assetWriter.status == AVAssetWriter.Status.unknown {
                        self.assetWriter.startWriting()
                        self.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sample))
                    }

                    if self.assetWriter.status == AVAssetWriter.Status.failed {
                        print("Error occured, status = \(self.assetWriter.status.rawValue), \(self.assetWriter.error!.localizedDescription) \(String(describing: self.assetWriter.error))")
                        return
                    }

                    if bufferType == .video {
                        if self.videoInput.isReadyForMoreMediaData {
                            self.videoInput.append(sample)
                        }
                    }
                }

            }) { error in
                recordingHandler(error)
//                debugPrint(error)
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func stopRecording(handler: @escaping (Error?) -> Void) {
        if #available(iOS 11.0, *) {
            RPScreenRecorder.shared().stopCapture { error in
                handler(error)
                self.assetWriter.finishWriting {
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

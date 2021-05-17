//
//  SharedView.swift
//  LidarRealityKit
//
//  Created by Tri Dang on 10/05/2021.
//

// import UIKit
import SwiftUI

struct SharedView: UIViewControllerRepresentable {
    @Binding var url: URL?
    @Binding var isPresent: Bool
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if let url = url, isPresent {
            let activityItem: [AnyObject] = [url as AnyObject]
            let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
            uiViewController.present(avc, animated: true)
            DispatchQueue.main.async {
                self.url = nil
                isPresent = false
            }
        }
    }
}

//
//  ScreenRecorder.swift
//  BTSHelper1
//
//  Created by Daniil Novoselov on 22.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import Foundation
import UIKit
import ReplayKit

class ScreenRecorder: UIViewController {
    func startRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = true
        recorder.isCameraEnabled = true
        recorder.delegate = self;
        
        recorder.startRecording { [unowned self] error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                MenuViewController.isRecording = true
                if let cameraPreviewView = recorder.cameraPreviewView {
                    cameraPreviewView.frame = CGRect(x: 0, y: self.topLayoutGuide.length, width: 100, height: 100)
                    self.view.addSubview(cameraPreviewView)
                }
            }
        }
    }
    
    
    func stopRecording() {
        let recorder = RPScreenRecorder.shared()
        
        recorder.stopRecording { [unowned self] previewController, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                MenuViewController.isRecording = false
                
                if let preview = previewController {
                    preview.previewControllerDelegate = self
                    
                    preview.modalPresentationStyle = .fullScreen
                    
                    if let popover = preview.popoverPresentationController {
                        //                        popover.barButtonItem = sender
                        popover.permittedArrowDirections = .any
                    }
                    
                    MenuViewController.getCurrentViewController()!.present(preview, animated: true)
                }
            }
        }
    }
    
    
    func cancelRecording() {
        let recorder = RPScreenRecorder.shared()
        
        recorder.discardRecording {
            MenuViewController.isRecording = false
        }
    }
    
    
    class func getCurrentViewController() -> UIViewController? {
        
        // If the root view is a navigation controller, we can just return the visible ViewController
        if let navigationController = getNavigationController() {
            
            return navigationController.visibleViewController
        }
        
        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
            while( currentController.presentedViewController != nil ) {
                
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    class func getNavigationController() -> UINavigationController? {
        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
            
            return navigationController as? UINavigationController
        }
        return nil
    }

}

extension ScreenRecorder: RPScreenRecorderDelegate {
    func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        print("screen recorder did change availability")
    }
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWithError error: Error, previewViewController: RPPreviewViewController?) {
        print("screen recorder did stop recording : \(error.localizedDescription)")
    }
    
}

extension ScreenRecorder: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        print("preview controller did finish")
        MenuViewController.getCurrentViewController()!.dismiss(animated: true, completion: nil)
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        print("preview controller did finish with activity types : \(activityTypes)")
        if activityTypes.contains("com.apple.UIKit.activity.SaveToCameraRoll") {
            // video has saved to camera roll
        } else {
            // cancel
        }
    }
}

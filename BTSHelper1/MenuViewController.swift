//
//  MenuViewController.swift
//  BTSHelper1
//
//  Created by Daniil Novoselov on 19.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import UIKit
import ReplayKit

class MenuViewController: UIAlertController {
    var recordAction: UIAlertAction?
    static var isRecording: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if RPScreenRecorder.shared().isAvailable {
            self.recordAction?.isEnabled = true
        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure() {
        let newIssueAction = UIAlertAction(title: "New issue", style: .default) { (alertAction) in
            let sb = UIStoryboard(name: "BTSHelper", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            
            let topVC = MenuViewController.getCurrentViewController()
            topVC!.present(vc!, animated: true, completion: nil)
        }
        self.recordAction = UIAlertAction(title: "Start screen recording", style: .default) { (alertAction) in
            if MenuViewController.isRecording {
                self.stopRecording()
            } else {
                self.startRecording()
            }
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        self.addAction(newIssueAction)
        self.addAction(self.recordAction!)
        self.addAction(settingsAction)
        self.addAction(cancelAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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


extension MenuViewController: RPScreenRecorderDelegate {
    func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        print("screen recorder did change availability")
    }
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWithError error: Error, previewViewController: RPPreviewViewController?) {
        print("screen recorder did stop recording : \(error.localizedDescription)")
    }

}

extension MenuViewController: RPPreviewViewControllerDelegate {
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

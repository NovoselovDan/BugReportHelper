//
//  UIViewControllerExtension.swift
//  BTSHelper1
//
//  Created by Daniil Novoselov on 19.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import Foundation
import UIKit
import ReplayKit

extension UIViewController {

    open override func becomeFirstResponder() -> Bool {
        return true
    }
    
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if !(self is BTSFormTableViewController ||
                self is BTSSelectionTableViewController ||
                self is BTSSinginViewController ||
                self is MenuViewController) {
                showMenu()
            }
        }
    }
    
    private func showMenu() {
        let menu = MenuViewController(title: "Bug reporting system menu", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)        
        self.present(menu, animated: true, completion: nil)
    }
}

extension UIViewController {
    func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
        
        let alertVC = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        debugPrint("show vc: \(String(describing: alertVC.title))\n\(String(describing: alertVC.message))")
        
    }
}

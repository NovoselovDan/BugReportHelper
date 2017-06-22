//
//  SampleViewController.swift
//  BTSHelper1
//
//  Created by Valera_IMac on 16.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import UIKit
import ReplayKit

class SampleViewController: UIViewController, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func actionBtnPressed(_ sender: UIButton) {
//        self.callBTSMenu()
    }
    
    func callBTSMenu() {
        let menu = UIAlertController(title: "Bug reporting system menu", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let newIssueAction = UIAlertAction(title: "New issue", style: .default, handler: nil)
        let recordAction = UIAlertAction(title: "Start screen recording", style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        menu.addAction(newIssueAction)
        menu.addAction(recordAction)
        menu.addAction(settingsAction)
        menu.addAction(cancelAction)
        
        self.present(menu, animated: true, completion: nil)
        
    }
}

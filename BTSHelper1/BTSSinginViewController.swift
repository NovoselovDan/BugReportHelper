//
//  BTSSinginViewController.swift
//  BTSHelper1
//
//  Created by Valera_IMac on 18.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import UIKit

class BTSSinginViewController: UIViewController {

    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var formTitle: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formTitle.text = "\(APIManager.shared.apiDelegate.baseURL)"
        
        self.activityIndicatorView.layer.cornerRadius = 10.0
        self.activityIndicatorView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if self.loginTextField.isFirstResponder {
            self.loginTextField.resignFirstResponder()
        }
        if self.passwordTextField.isFirstResponder {
            self.passwordTextField.resignFirstResponder()
        }
        
        self.activityIndicatorView.isHidden = false
        
        if !(self.loginTextField.text?.isEmpty)! && !(self.passwordTextField.text?.isEmpty)! {
            self.makeSignInRequest(userLogin: self.loginTextField.text!, userPassword: self.passwordTextField.text!)
        } else {
            self.activityIndicatorView.isHidden = true
            self.displayAlertMessage(alertTitle: "Fields required", alertDescription: "Some of fields are empty")
        }
    }
    
    func makeSignInRequest(userLogin:String, userPassword:String) {
        APIManager.shared.signin(login: userLogin, password: userPassword) { (data, error) in
            self.activityIndicatorView.isHidden = true
            if error != nil {
                self.displayAlertMessage(alertTitle: "Login error", alertDescription: error!.localizedDescription)
            }
        }
    }
}

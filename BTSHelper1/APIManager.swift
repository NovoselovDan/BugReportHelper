//
//  APIManager.swift
//  BTSHelper1
//
//  Created by Valera_IMac on 16.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import UIKit

class APIManager: NSObject {
    private static var instance: APIManager?
    private static var prefferedAPIDelegate: APIDelegate?

    let apiDelegate: APIDelegate
    
    class var shared: APIManager {
        if instance == nil {
            instance = APIManager()
        }
        
        return instance!
    }
    private override init() {
        self.apiDelegate = APIManager.prefferedAPIDelegate!
    }
    
    static func setPreferredAPIDelegate(delegate: APIDelegate) {
        prefferedAPIDelegate = delegate
    }
    
    
    func isAuthorized() -> Bool {
        return self.apiDelegate.isAuthorized()
    }
    
    func sendIssue(issue: Issue, sender: UIViewController, completion: @escaping (_ error: Error?, _ response: AnyObject?) -> Void) {
        self.apiDelegate.sendIssue(issue: issue, completion: { (error, response) in
            if error != nil {
                completion(error, nil)
            } else {
                completion(nil, response as AnyObject)
            }
        })
    }
    
    func createIssue() -> Issue {
        return apiDelegate.createIssue()
    }
    
    func signin(login: String, password: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        self.apiDelegate.signIn(login: login, password: password) { (error, data) in
            if let err = error {
                completion (nil, err)
                KeychainAccess.deletePasswordForAccount(password: password, account: login)
            } else {
                self.updateUserLoggedInFlag()
                KeychainAccess.setPassword(password: password, account: login)
                let userDefaults = UserDefaults.standard
                userDefaults.set(login, forKey: Constants.kLogin)
                userDefaults.synchronize()
                
                completion(data as? Data, nil)
            }
        }
    }
    
    
    //private methods
    
    private func updateUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        let defaults = UserDefaults.standard
        defaults.set("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
}

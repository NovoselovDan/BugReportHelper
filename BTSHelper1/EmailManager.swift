//
//  EmailManager.swift
//  BTSHelper1
//
//  Created by Daniil Novoselov on 19.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import UIKit
import MessageUI

class EmailManager: NSObject, APIDelegate {
    var email = "Default@gmail.com"
    var baseURL = ""
    
    init(email: String) {
        self.email = email
    }
    
    func sendIssue(issue: Issue, completion:@escaping (Error?, AnyObject?) -> Void) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients([email])
            let Eissue = issue as! EmailIssue
            mail.setMessageBody("<p>\(Eissue.descriptionText())</p>", isHTML: true)
            
            completion(nil, mail)
        } else {
            completion(nil, nil)
        }
    }
    
    func isAuthorized() -> Bool {
        return true
    }
    
    func createIssue() -> Issue {
        return EmailIssue()
    }
    
    func signIn(login: String, password: String, completion: @escaping (Error?, AnyObject?) -> Void) {
        //Not required
    }
}

//
//  JIRAManager.swift
//  BTSHelper1
//
//  Created by Daniil Novoselov on 18.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import UIKit

class JIRAManager: NSObject, APIDelegate {

    var baseURL: String

    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func isAuthorized() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: Constants.kLoggedIn) != nil
    }
    
    func sendIssue(issue: Issue, completion: @escaping (Error?, AnyObject?) -> Void) {
        let pathURL = "/rest/api/2/issue"
        var request = buildRequest(path: pathURL, method: "POST", authType: .HTTPBasicAuth, requestContentType: .HTTPJsonContent)
        let json = issue.jsonData()
        request.httpBody = json
        
        sendRequest(request: request) { (data, error, response) in
            if error != nil {
                completion(error!, nil)
            }
            
        }
    }
    
    func createIssue() -> Issue {
        return JIRAIssue()
    }
    
    
    func signIn(login: String, password: String, completion: @escaping (Error?, AnyObject?) -> Void) {
        let pathURL = "/rest/api/2//mypermissions"
        let request = buildRequest(path: pathURL, method: "GET", authType: .HTTPBasicAuth, login: login, password: password)
        
        sendRequest(request: request) { (data, error, response) in
            print("response: \(String(describing: response))")
            print("response: \(String(describing: error))")
            print("response: \(String(describing: data))")

            if error != nil {
                completion(error!, nil)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(nil, data as AnyObject)
                    }
                }
            }
        }
    }
}

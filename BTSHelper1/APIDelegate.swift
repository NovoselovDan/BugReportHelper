//
//  APIDelegate.swift
//  BTSHelper1
//
//  Created by Valera_IMac on 18.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import UIKit

enum HTTPRequestAuthType {
    case HTTPBasicAuth
    case HTTPTokenAuth
}

enum HTTPRequestContentType {
    case HTTPJsonContent
    case HTTPMultipartContent
}

protocol APIDelegate {
    var baseURL: String {get}
    
    func isAuthorized() -> Bool
    func sendIssue(issue: Issue, completion:@escaping (_ error: Error?, _ response: AnyObject?) -> Void) -> Void
    func signIn(login: String, password: String, completion:@escaping (_ error: Error?, _ response: AnyObject?) -> Void) -> Void
    func createIssue() -> Issue
}

extension APIDelegate {
    
    internal func buildRequest(path: String!,
                               method: String,
                               authType: HTTPRequestAuthType,
                               requestContentType: HTTPRequestContentType = HTTPRequestContentType.HTTPJsonContent,
                               requestBoundary: String = "") -> URLRequest {
        return buildRequest(path: path,
                            method: method,
                            authType: authType,
                            requestContentType: requestContentType,
                            requestBoundary: requestBoundary,
                            login: nil, password: nil)
    }
    
    internal func buildRequest(path: String!,
                               method: String,
                               authType: HTTPRequestAuthType,
                               requestContentType: HTTPRequestContentType = HTTPRequestContentType.HTTPJsonContent,
                               requestBoundary: String = "",
                               login: String?,
                               password: String?) -> URLRequest {
        let urlStr = self.baseURL.appending(path) //"\(self.baseURL)\(path)"
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        
        request.httpMethod = method
        
        switch requestContentType {
        case .HTTPJsonContent:
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .HTTPMultipartContent:
            let contentType = "multipart/form-data; boundary=\(requestBoundary)"
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            request.addValue("nocheck", forHTTPHeaderField: "X-Atlassian-Token")
        }
        
        switch authType {
        case .HTTPBasicAuth:
            var basicAuthString: String
            if let logg = login, let pass = password {
                basicAuthString = "\(logg):\(pass)"
            } else {
                basicAuthString = "\(getLogin()):\(getPassword())"
            }
            let utf8str = basicAuthString.data(using: String.Encoding.utf8)
            let base64EncodedStr = utf8str?.base64EncodedString(options:NSData.Base64EncodingOptions(rawValue: 0))
            
            request.addValue("Basic \(base64EncodedStr!)", forHTTPHeaderField: "Authorization")
        case .HTTPTokenAuth:
            // Retreieve Auth_Token from Keychain
            if let userToken = KeychainAccess.passwordForAccount(account: "Auth_Token", service: "KeyChainService"){
                request.addValue("Token token=\(userToken)", forHTTPHeaderField: "Authorization")
            }
        }
        
        return request
    }
    
    
    internal func sendRequest(request: URLRequest, completion:@escaping (Data?, Error?, URLResponse?) -> Void) -> Void {
        // Create a NSURLSession task
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(data, error, response)
                }
                return
            }
            
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(data, nil, response)
                    } else {
                        if let errorDict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) {
                            let responseError = NSError(domain: "HTTPHelperError", code: httpResponse.statusCode, userInfo: errorDict as? [String : AnyObject])
                            completion(data, responseError, nil)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    
    internal func uploadRequest(path: String, attachments: [Attachment], title: String) -> URLRequest {
        let boundary = boundaryString()

        var request = buildRequest(path: path,
                                   method: "POST",
                                   authType: HTTPRequestAuthType.HTTPBasicAuth,
                                   requestContentType: HTTPRequestContentType.HTTPMultipartContent,
                                   requestBoundary: boundary)
        
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let httpBody = createBodyWithBoundary(boundary: boundary, attachments: attachments)
        
        if var body = request.httpBody {
            body.append(httpBody)
        } else {
            request.httpBody = httpBody
        }
        
        return request
    }


    func boundaryString() -> String {
        let uuidStr = UUID().uuidString
        return "Boundary-\(uuidStr)"
    }
    
    func createBodyWithBoundary(boundary: String, attachments: [Attachment]) -> Data {
        let httpBody = NSMutableData()
        
        for attach in attachments {
            httpBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            httpBody.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(attach.filename))\"\r\n".data(using: .utf8)!)
            httpBody.append("Content-Type: \(attach.mimeType)\r\n\r\n".data(using: .utf8)!)
            httpBody.append(attach.attachmentData)
            httpBody.append("\r\n".data(using: .utf8)!)
        }
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return httpBody as Data
    }
    
    private func getLogin() -> String {
        return UserDefaults.standard.object(forKey: Constants.kLogin) as! String
    }
    private func getPassword() -> String {
        let account = getLogin()
        return KeychainAccess.passwordForAccount(account: account)!
    }
}

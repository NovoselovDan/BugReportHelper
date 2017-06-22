//
//  JIRAIssue.swift
//  BTSHelper1
//
//  Created by Daniil Novoselov on 22.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import Foundation

class JIRAIssue: NSObject, Issue {
    var fields: [Field]
    var attachments: [Attachment]?
    var idValue: String?
    var expand: URL?
    var key: String?
    var selfLink: URL?
    
    override init() {
        fields = [Field]()
    }
    
    func jsonData() -> Data? {
        return Data()
    }
}

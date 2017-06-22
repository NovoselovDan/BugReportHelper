//
//  EmailIssue.swift
//  BTSHelper1
//
//  Created by Daniil Novoselov on 22.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import Foundation

class EmailIssue: NSObject, Issue {
    var fields: [Field]
    var attachments: [Attachment]?
    var idValue: String?
    
    override init() {
        fields = [Field]()
    }
    
    func descriptionText() -> String {
        var text = String()
        
        for field in self.fields {
            text.append("\(field.name):\t\(field.value)\n")
        }
        return text
    }
    
    func jsonData() -> Data? {
        return nil
    }
}

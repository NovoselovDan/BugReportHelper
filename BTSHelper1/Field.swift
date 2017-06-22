//
//  Field.swift
//  BTSHelper1
//
//  Created by Daniil Novoselov on 22.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import Foundation

class Field {
    let issue: Issue
    var name: String
    var value: String
    
    init(issue: Issue) {
        self.issue = issue
        self.name = " "
        self.value = " "
    }
}

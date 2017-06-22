//
//  Isssue.swift
//  BTSHelper1
//
//  Created by Valera_IMac on 16.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import Foundation
import UIKit

protocol Issue {
    var idValue: String? {get}
    var fields: [Field] {get set}
    var attachments: [Attachment]? {get set}
    
    func jsonData() -> Data?
}

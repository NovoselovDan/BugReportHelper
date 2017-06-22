//
//  Attachment.swift
//  BTSHelper1
//
//  Created by Valera_IMac on 17.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import Foundation
import UIKit


enum MimeType: String {
    case imagePng = "image/png"
    case plainTxt = "plane/txt"
}

class Attachment: NSObject {
    let filename: String
    let mimeType: String
    let attachmentData: Data
    
    init(filename: String, mimeType: MimeType, attachmentData: Data) {
        self.filename = filename
        self.mimeType = mimeType.rawValue
        self.attachmentData = attachmentData
    }
    
}

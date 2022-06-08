//
//  File.swift
//  
//
//  Created by Bruno Antoninho on 07/06/2022.
//

import Foundation

public class AttachmentPicked {
    
    var fileType: String!
    var fileName: String!
    var fileSize: Int!
    var mimeType: String!
    var blob: String!
    
    //For internal use
    var uncompressedFile: Data!
}

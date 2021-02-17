//
//  VideoMessage.swift
//  InputBarAccessoryView
//
//  Created by Samuel Folledo on 11/22/20.
//  Copyright © 2020 Nathan Tannar. All rights reserved.
//

import UIKit

public class VideoMessage {
    
    public var name: String
    public var downloadUrl: URL? //video's Firebase URL
    public var localUrl: URL? //video's local url
    public var thumbnailUrl: URL?
    public var thumbnailImage: UIImage?
    public var duration: Double?
    
    public var asDictionary: NSDictionary {
        get {
            let videoDictionary: NSDictionary = [
                "name": name,
                "downloadUrl": downloadUrl?.absoluteString ?? "",
                "thumbnailUrl": localUrl?.absoluteString ?? "",
                "thumbnailUrl": thumbnailUrl?.absoluteString ?? "",
                "duration": duration ?? 0.0,
                
            ]
            return videoDictionary
        }
    }
    
    //MARK: Initializers
    
    ///initializer for sending a message
    public init(localUrl: URL, duration: Double, thumbnailImage: UIImage) {
        self.localUrl = localUrl
        self.name = localUrl.lastPathComponent
        self.duration = duration
        self.thumbnailImage = thumbnailImage
    }
    
    ///initializer for loading a message received
    public init(downloadUrl: URL, thumbnailUrl: URL) {
        self.downloadUrl = downloadUrl
        self.name = downloadUrl.lastPathComponent
        self.thumbnailUrl = thumbnailUrl
    }
    
    ///custom initializer
    public init(downloadUrl: URL? = nil, localUrl: URL? = nil, name: String = "", duration: Double? = nil, thumbnailImage: UIImage = UIImage()) {
        self.downloadUrl = downloadUrl
        self.localUrl = localUrl
        self.name = name
        self.duration = duration
        self.thumbnailImage = thumbnailImage
    }
}

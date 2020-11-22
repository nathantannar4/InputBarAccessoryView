//
//  VideoMessage.swift
//  InputBarAccessoryView
//
//  Created by Samuel Folledo on 11/22/20.
//  Copyright © 2020 Nathan Tannar. All rights reserved.
//

import UIKit

public class VideoMessage {
    public var localUrl: URL?
    public var name: String
    public var url: URL?
    public var duration: Double?
    public var thumbnailImage: UIImage?
    public var thumbNailUrl: URL?
    public var asDictionary: NSDictionary {
        get {
            let videoDictionary: NSDictionary = [
                "urlString": localUrl?.absoluteString ?? "",
                "image": thumbnailImage ?? UIImage(),
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
    public init(videoUrl: URL, thumbnailUrl: URL) {
        self.url = videoUrl
        self.name = videoUrl.lastPathComponent
        self.thumbNailUrl = thumbnailUrl
    }
    
    ///custom initializer
    public init() {
        self.name = ""
    }
}

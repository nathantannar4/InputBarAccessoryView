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
    public var videoUrl: URL? //video's Firebase URL
    public var videoLocalUrl: URL? //video's local url
    public var thumbnailUrl: URL?
    public var thumbnailImage: UIImage?
    public var duration: Double?
    
    public var asDictionary: NSDictionary {
        get {
            let videoDictionary: NSDictionary = [
                "name": name,
                "videoUrl": videoUrl?.absoluteString ?? "",
                "videoLocalUrl": videoLocalUrl?.absoluteString ?? "",
                "thumbnailUrl": thumbnailUrl?.absoluteString ?? "",
                "duration": duration ?? 0.0,
                
            ]
            return videoDictionary
        }
    }
    
    //MARK: Initializers
    
    ///initializer for sending a message
    public init(videoLocalUrl: URL, duration: Double, thumbnailImage: UIImage) {
        self.videoLocalUrl = videoLocalUrl
        self.name = videoLocalUrl.lastPathComponent
        self.duration = duration
        self.thumbnailImage = thumbnailImage
    }
    
    ///initializer for loading a message received
    public init(videoUrl: URL, thumbnailUrl: URL) {
        self.videoUrl = videoUrl
        self.name = videoUrl.lastPathComponent
        self.thumbnailUrl = thumbnailUrl
    }
    
    ///custom initializer
    public init() {
        self.name = ""
    }
}

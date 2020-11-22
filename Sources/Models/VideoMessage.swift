//
//  VideoMessage.swift
//  InputBarAccessoryView
//
//  Created by Samuel Folledo on 11/22/20.
//  Copyright © 2020 Nathan Tannar. All rights reserved.
//

import UIKit

public struct VideoMessage {
    public var thumbnailImage: UIImage?
    public var duration: Double?
    public var localUrl: URL?
    public var firebasePath: String?
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
    public init(localUrl: URL, duration: Double, thumbnailImage: UIImage) {
        self.localUrl = localUrl
        self.duration = duration
        self.thumbnailImage = thumbnailImage
    }
}

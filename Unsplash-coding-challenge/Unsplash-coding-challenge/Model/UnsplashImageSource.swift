//
//  UnsplashImageSource.swift
//  Unsplash-coding-challenge
//
//  Created by Paul on 2018-08-24.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation

class UnsplashImageSource {
    
    var imageString: String
    var photographerName: String
    var photoId: String
    
    init(imageString: String, photograherName: String, photoId: String) {
        self.imageString = imageString
        self.photographerName = photograherName
        self.photoId = photoId
    }
    
}

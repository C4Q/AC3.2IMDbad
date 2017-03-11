//
//  AlbumImage.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/8/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

class AlbumImage {
    let height: Int
    let width: Int
    let urlString: String
    
    init?(from dictionary: [String:AnyObject]) {
        if let height = dictionary["height"] as? Int,
            let width = dictionary["width"] as? Int,
            let url = dictionary["url"] as? String {
            self.height = height
            self.width = width
            self.urlString = url
        }
        else {
            return nil
        }
    }
}

//
//  Soundtrack.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/8/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

enum SoundtrackModelParseError: Error {
    case results(json: Any)
    case image(image: Any)
}

class Soundtrack {
    let title: String
    let artistName: String
    let images: [AlbumImage]
    
    init(title: String, artistName: String, images: [AlbumImage]) {
        self.title = title
        self.artistName = artistName
        self.images = images
    }
    
    convenience init?(withDict: [String: AnyObject]) throws {
        if let title = withDict["name"] as? String,
        let artistDictArr = withDict["artists"] as? [[String: AnyObject]],
            let imageDictArr = withDict["images"] as? [[String: AnyObject]] {
            
            var imageArr = [AlbumImage]()
            for imageDict in imageDictArr {
                if let imageObject = AlbumImage(from: imageDict) {
                    imageArr.append(imageObject)
                } else {
                    print("***************** Image Parse Error")
                }
            }
            let artistName = artistDictArr.count > 0 ? artistDictArr[0]["name"] as? String ?? "N/A" : "N/A"
            
            self.init(title: title, artistName: artistName, images: imageArr)
            
        } else {
            return nil
        }
    }
}

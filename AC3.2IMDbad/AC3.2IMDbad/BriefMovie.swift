//
//  BriefMovie.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/8/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

enum BriefMovieModelParseError: Error {
    case results(json: Any)
}

class BriefMovie {
    
    internal let title: String
    internal let year: String
    internal let imdbID: String
    internal let type: String
    internal let poster: String
    internal var titleSearchString: String {
        return self.title.replacingOccurrences(of: " ", with: "%20")
    }
    
    init(title: String, year: String, imdbID: String, type: String, poster: String) {
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.type = type
        self.poster = poster
    }
    
    convenience init?(withDict: [String: String]) throws {
        if let bmTitle = withDict["Title"],
            let bmId = withDict["imdbID"],
            let bmYear = withDict["Year"],
            let bmType = withDict["Type"],
            let bmPoster = withDict["Poster"] {
            
            self.init(title: bmTitle, year: bmYear, imdbID: bmId, type: bmType, poster: bmPoster)
        }
        else {
            return nil
        }
    }
}

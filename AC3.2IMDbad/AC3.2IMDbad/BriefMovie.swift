//
//  BriefMovie.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/8/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

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
    
    convenience init?(withDict: [String: String]) {
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
    
    static func buildBriefMovieArray(from data: Data) -> [BriefMovie]? {
        
        do {
            let movieJSONdata: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let resultDict = movieJSONdata as? [String: AnyObject] else {
                print("first error")
                return nil
            }
            
            guard let arrOfMovieDict = resultDict["Search"] as? [[String: String]] else { return nil }
            
            var arrOfBriefMovies: [BriefMovie] = []
            
            for dict in arrOfMovieDict {
                if let thisBriefMovie = BriefMovie(withDict: dict) {
                    arrOfBriefMovies.append(thisBriefMovie)
                }
            }
            return arrOfBriefMovies
            
        } catch let error as NSError {
            print("error here \(error)")
            return nil
        }
    }
}

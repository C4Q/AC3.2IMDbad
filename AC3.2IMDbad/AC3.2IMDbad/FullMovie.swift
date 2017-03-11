//
//  FullMovie.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/8/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

class FullMovie {
    
    let title: String
    let year: String
    let genre: String
    let plot: String
    let posterURL: String
    let runtime: String
    let cast: String
    let imdbRating: String
    let rated: String
    
    init(title: String, year: String, genre: String, runtime: String, plot: String, posterURL: String, cast: String, imdbRating: String, rated: String) {
        self.title = title
        self.year = year
        self.genre = genre
        self.plot = plot
        self.posterURL = posterURL
        self.runtime = runtime
        self.cast = cast
        self.imdbRating = imdbRating
        self.rated = rated
    }
    
    convenience init?(withDict: [String: String]) {
        if let fmTitle = withDict["Title"],
            let fmYear = withDict["Year"],
            let fmGenre = withDict["Genre"],
            let fmPlot = withDict["Plot"],
            let fmPoster = withDict["Poster"],
            let fmRuntime = withDict["Runtime"],
            let fmCast = withDict["Actors"],
            let fmRating = withDict["imdbRating"],
            let fmRated = withDict["Rated"] {
            
            self.init(title: fmTitle, year: fmYear, genre: fmGenre, runtime: fmRuntime, plot: fmPlot, posterURL: fmPoster, cast: fmCast, imdbRating: fmRating, rated: fmRated)
        } else {
            return nil
        }
    }
    
    static func getFullMovie(from data: Data) -> FullMovie? {
        
        do {
            let movieJSONData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let movieDict = movieJSONData as? [String: String] else { print("\n\n\n\n\n______________________\n\n"); return nil }
            
            let thisFullMovie = FullMovie(withDict: movieDict)
            print(thisFullMovie)
            return thisFullMovie
            
        }
        catch let error as NSError {
            print("Error occurred while parsing data: \(error.localizedDescription)\n\n\n\n\n\n_____________________________________")
        }
        return nil
    }
    
}

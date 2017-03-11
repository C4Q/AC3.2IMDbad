//
//  Movie.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/11/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

class Movie {
    let briefInfo: BriefMovie
    var fullInfo: FullMovie?
    var soundtracks: [Soundtrack]?
    
    init(briefInfo: BriefMovie) {
        self.briefInfo = briefInfo
    }
    
    static func buildMovieArray(from data: Data) -> [Movie]? {
        
        do {
            let movieJSONdata: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let resultDict = movieJSONdata as? [String: AnyObject] else {
                throw BriefMovieModelParseError.results(json: movieJSONdata)
            }
            
            guard let arrOfMovieDict = resultDict["Search"] as? [[String: String]] else { return nil }
            
            var arrOfMovies: [Movie] = []
            
            for dict in arrOfMovieDict {
                
                if let thisBriefMovie = try BriefMovie(withDict: dict) {
                    let thisMovie = Movie(briefInfo: thisBriefMovie)
                    arrOfMovies.append(thisMovie)
                }
            }
            return arrOfMovies
            
        }
        catch let BriefMovieModelParseError.results(json: json)  {
            print("Error encountered with parsing key for object: \(json)")
        }
        catch {
            print("Unknown BriefMovie parsing error")
        }
        return nil
    }
    
    static func getFullMovie(from data: Data) -> FullMovie? {
        
        do {
            let movieJSONData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let movieDict = movieJSONData as? [String: String] else {
                throw FullMovieModelParseError.results(json: movieJSONData)
            }
            
            if let thisFullMovie = try FullMovie(withDict: movieDict) {
                print(thisFullMovie)
                return thisFullMovie
            }
            
        }
        catch let FullMovieModelParseError.results(json: json)  {
            print("Error encountered with parsing key for object: \(json)")
        }
        catch {
            print("Unknown FullMovie parsing error")
        }
        return nil
    }
    
    static func buildSoundtrackArray(from data: Data) -> [Soundtrack]? {
        var soundtracksToReturn: [Soundtrack]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [String : AnyObject] = jsonData as? [String : AnyObject],
                let albums = response["albums"] as? [String: AnyObject],
                let items = albums["items"] as? [[String: AnyObject]] else {
                    throw SoundtrackModelParseError.results(json: jsonData)
            }
            
            for soundtrackDict in items {
                if let thisSoundtrack = try Soundtrack(withDict: soundtrackDict) {
                    soundtracksToReturn?.append(thisSoundtrack)
                }
            }
        }
        catch let SoundtrackModelParseError.results(json: json)  {
            print("Error encountered with parsing 'album' or 'items' key for object: \(json)")
        }
        catch let SoundtrackModelParseError.image(image: im)  {
            print("Error encountered with parsing 'image': \(im)")
        }
        catch {
            print("Unknown Soundtrack parsing error")
        }
        
        return soundtracksToReturn
    }

}

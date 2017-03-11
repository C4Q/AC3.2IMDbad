//
//  BriefMovieTableViewController.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/8/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class BriefMovieTableViewController: UITableViewController {
    var briefMovies = [BriefMovie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        let apiEndpoint = "https://www.omdbapi.com/?s=batman"
        APIManager.manager.getData(endPoint: apiEndpoint) { (data: Data?) in
            guard let unwrappedData = data else { return }
            self.briefMovies = BriefMovie.buildBriefMovieArray(from: unwrappedData)!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return briefMovies.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "briefMovieTableViewCell", for: indexPath)
        let thisBriefMovie = briefMovies[indexPath.row]
        cell.textLabel?.text = thisBriefMovie.title
        APIManager.manager.getData(endPoint: thisBriefMovie.poster) { (data: Data?) in
            guard let unwrappedData = data else { return }
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: unwrappedData)
                cell.setNeedsLayout()
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisBriefMovie = briefMovies[indexPath.row]
        
        let fullMovieAPIEndpoint = "https://www.omdbapi.com/?i=\(thisBriefMovie.imdbID)"
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + fullMovieAPIEndpoint)
        APIManager.manager.getData(endPoint: fullMovieAPIEndpoint) { (data: Data?) in
            guard let unwrappedData = data else { return }
            let thisFullMovie = FullMovie.getFullMovie(from: unwrappedData)
            dump(thisFullMovie)
        }
        
        let soundtrackAPIEndpoint = "https://api.spotify.com/v1/search?q=\(thisBriefMovie.titleSearchString)&type=album&limit=50"
        APIManager.manager.getData(endPoint: soundtrackAPIEndpoint) { (data: Data?) in
            guard let unwrappedData = data else { return }
            let arrayOfSoundtracks = Soundtrack.buildSoundtrackArray(from: unwrappedData)
            dump(arrayOfSoundtracks)
        }
        
        let imdbString = "http://www.imdb.com/title/" + thisBriefMovie.imdbID
        guard let url = URL(string: imdbString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}

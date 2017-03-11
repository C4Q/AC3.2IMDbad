//
//  FullMovieDetailViewController.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/9/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class FullMovieDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout  {
    
    var soundtracks: [Soundtrack]! = []
    var thisFullMovie: FullMovie!
    
    var thisBriefMovie: BriefMovie!

    @IBOutlet weak var FullMovieImageView: UIImageView!
    @IBOutlet weak var FullMovieTitileLabel: UILabel!
    @IBOutlet weak var soundtrackCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFullMovieData()
        loadSoundtrackData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "imdb", style: .plain, target: self, action: #selector(goToIMDb))
    }
    
    func loadFullMovieData() {
        let fullMovieAPIEndpoint = "https://www.omdbapi.com/?i=\(thisBriefMovie.imdbID)"

        APIManager.manager.getData(endPoint: fullMovieAPIEndpoint) { (data: Data?) in
            guard let unwrappedData = data else { return }
            self.thisFullMovie = FullMovie.getFullMovie(from: unwrappedData)
            DispatchQueue.main.async {
                print("*****************FULL MOVIE*****************************")
                dump(self.thisFullMovie)
                self.navigationItem.title = self.thisFullMovie.title
                self.FullMovieTitileLabel.text = self.bulidFullMovieLabelText(withFullMovie: self.thisFullMovie)
            }
            APIManager.manager.getData(endPoint: self.thisFullMovie.posterURL) { (data: Data?) in
                guard let unwrappedData = data else { return }
                DispatchQueue.main.async {
                    self.FullMovieImageView.image = UIImage(data: unwrappedData)
                    self.view.reloadInputViews()
                }
            }
        }
    }
    
    func loadSoundtrackData() {
        let soundtrackAPIEndpoint = "https://api.spotify.com/v1/search?q=\(thisBriefMovie.titleSearchString)&type=album&limit=50"
        APIManager.manager.getData(endPoint: soundtrackAPIEndpoint) { (data: Data?) in
            guard let unwrappedData = data else { return }
            self.soundtracks = Soundtrack.buildSoundtrackArray(from: unwrappedData)
            if self.soundtracks.count > 0 {
                print("________________________ This is the soundtrack! ______________________________")
                dump(self.soundtracks[0])
            } else {
                print("____________________ NO SOUNDTRACKS___________________")
            }
        }
    }
    
    @IBAction func goToIMDb(_ sender: UIButton) {
        let imdbString = "http://www.imdb.com/title/" + thisBriefMovie.imdbID
        guard let url = URL(string: imdbString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    func bulidFullMovieLabelText(withFullMovie tfm: FullMovie) -> String {
        return "\(tfm.year), Rated: \(tfm.rated), Runtime: \(tfm.runtime), IMDb Rating: \(tfm.imdbRating)\nGenre: \(tfm.genre)\nCast: \(tfm.cast)\nSummary:   \(tfm.plot)"
    }
    
    // MARK: Collection View Data Souce Methods
    
    private let soundtrackReuseIdentifier = "soundtrackCell"
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("___________________ Collection View Something ___________________")
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return soundtracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.soundtrackReuseIdentifier, for: indexPath) as! SoundtrackCollectionViewCell
        let thisSoundtrack = soundtracks[indexPath.item]
        
        cell.soundtrackTextLabel.text = "\(thisSoundtrack.title)\n-\(thisSoundtrack.artistName)"
        
        APIManager.manager.getData(endPoint: thisSoundtrack.images[2].urlString) { (data: Data?) in
            guard let unwrappedData = data else { return }
            DispatchQueue.main.async {
                cell.soundtrackImageView?.image = UIImage(data: unwrappedData)
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    private let itemsPerColumn = CGFloat(1)
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerColumn + 1)
        let availableHeight = view.frame.width - paddingSpace
        let heightPerItem = availableHeight / itemsPerColumn
        
        return CGSize(width: heightPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }


//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let thisBriefMovie = briefMovies[indexPath.item]
//        let thisFullMovieAPIEndpoint = self.fullMovieAPIEndpoint + thisBriefMovie.imdbID
//        
//        APIManager.manager.getData(endPoint: thisFullMovieAPIEndpoint) { (data: Data?) in
//            guard let unwrappedData = data else { return }
//            let thisFullMovie = FullMovie.getFullMovie(from: unwrappedData)
//            dump(thisFullMovie)
//        }
//        performSegue(withIdentifier: fullMovieDetailSegue, sender: thisBriefMovie)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == fullMovieDetailSegue {
//            let destinationViewController = segue.destination as! FullMovieDetailViewController
//            let thisBriefMovie = sender as! BriefMovie
//            
//            destinationViewController.thisBriefMovie = thisBriefMovie
//        }
//    }
//    
//    


    
    
    // MARK: OLD CODE PIECES
    
    //      Biulds albumArray
    
    //        let soundtrackAPIEndpoint = "https://api.spotify.com/v1/search?q=\(thisBriefMovie.titleSearchString)&type=album&limit=50"
    //        APIManager.manager.getData(endPoint: soundtrackAPIEndpoint) { (data: Data?) in
    //            guard let unwrappedData = data else { return }
    //            let arrayOfSoundtracks = Soundtrack.buildSoundtrackArray(from: unwrappedData)
    //            dump(arrayOfSoundtracks)
    //        }

}




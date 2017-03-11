//
//  FullMovieDetailViewController.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/9/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class FullMovieDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var thisMovie: Movie!
    
    let soundtrackDetailSegue = "soundtrackDetailSegue"

    
    @IBOutlet weak var fullMovieBackgroundImage: UIImageView!
    @IBOutlet weak var noAlbumFoundImage: UIImageView!
    @IBOutlet weak var fullMovieImageView: UIImageView!
    @IBOutlet weak var soundtrackCollectionView: UICollectionView!
    
    @IBOutlet weak var imdbRating: UILabel!
    @IBOutlet weak var fullMovieYear: UILabel!
    @IBOutlet weak var fullMovieDescription: UILabel!
    @IBOutlet weak var fullMovieRating: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadFullMovieData()
        loadSoundtrackData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "IMDbButton2"), style: .plain, target: self, action: #selector(goToIMDb))
       
    }
    
    
    func loadFullMovieData() {
        
        self.fullMovieImageView.image = #imageLiteral(resourceName: "loadingImage")

        // CHECK HERE TO SEE IF THIS MOVIE ALREADY HAS A FULL MOVIE BEFORE API CALL
   
        if thisMovie.fullInfo == nil {
            
            let fullMovieAPIEndpoint = "https://www.omdbapi.com/?i=\(thisMovie.briefInfo.imdbID)"
            
            APIManager.manager.getData(endPoint: fullMovieAPIEndpoint) { (data: Data?) in
                guard let unwrappedData = data else { return }
                self.thisMovie.fullInfo = Movie.getFullMovie(from: unwrappedData)
               
                DispatchQueue.main.async {
                    print("*****************FULL MOVIE*****************************")
                    dump(self.thisMovie.fullInfo)
                    self.displayFullMovieInfo()
                    self.fullMovieImageView.image = #imageLiteral(resourceName: "noAvailableImage")
                }
                
                APIManager.manager.getData(endPoint: self.thisMovie.fullInfo!.posterURL) { (data: Data?) in
                    guard let unwrappedData = data else { return }
                    self.thisMovie.fullInfo?.posterData = unwrappedData
                    DispatchQueue.main.async {
                        self.fullMovieImageView.image = UIImage(data: unwrappedData)
                        self.fullMovieBackgroundImage.image = UIImage(data: unwrappedData)
                        self.view.reloadInputViews()
                    }
                }
            }
            
        } else {
            self.displayFullMovieInfo()
        }
    }
    
    func displayFullMovieInfo() {
        self.navigationItem.title = self.thisMovie.fullInfo!.title
        self.imdbRating.text = "IMDb Rating: \(self.thisMovie.fullInfo!.imdbRating)/10"
        self.fullMovieYear.text = "Released: \(self.thisMovie.fullInfo!.year)"
        self.fullMovieRating.text = "Rated: \(self.thisMovie.fullInfo!.rated)"
        self.fullMovieDescription.text = self.thisMovie.fullInfo?.plot
        if let fullMoviePosterData = thisMovie.fullInfo?.posterData {
            self.fullMovieImageView.image = UIImage(data: fullMoviePosterData)
            self.fullMovieBackgroundImage.image = UIImage(data: fullMoviePosterData)
        } else {
            self.fullMovieImageView.image = #imageLiteral(resourceName: "noAvailableImage")
        }
    }

    
    func loadSoundtrackData() {
        
        if thisMovie.soundtracks == nil {
            let soundtrackAPIEndpoint = "https://api.spotify.com/v1/search?q=\(thisMovie.briefInfo.titleSearchString)&type=album&limit=50"
            APIManager.manager.getData(endPoint: soundtrackAPIEndpoint) { (data: Data?) in
                guard let unwrappedData = data else { return }
                self.thisMovie.soundtracks = Movie.buildSoundtrackArray(from: unwrappedData)
                if (self.thisMovie.soundtracks?.count)! > 0 {
                    DispatchQueue.main.async {
                        self.soundtrackCollectionView.reloadData()
                    }
                    print("________________________ This is the first album in soundtracks ______________________________")
                    dump(self.thisMovie.soundtracks?[0])
                } else {
                    self.noAlbumFoundImage.isHidden = false
                    print("____________________ NO SOUNDTRACKS___________________")
                }
            }
        }
        
    }
    
    @IBAction func goToIMDb(_ sender: UIButton) {
        let imdbString = "http://www.imdb.com/title/" + thisMovie.briefInfo.imdbID
        guard let url = URL(string: imdbString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    // MARK: Collection View Data Souce Methods
    
    private let soundtrackReuseIdentifier = "soundtrackCell"
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("___________________ Collection View Something ___________________")
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if thisMovie.soundtracks != nil {
            if (thisMovie.soundtracks?.count)! > 0 {
                return (thisMovie.soundtracks?.count)!
            } else {
                self.soundtrackCollectionView.backgroundView?.isHidden = false
                return 0
            }
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.soundtrackReuseIdentifier, for: indexPath) as! SoundtrackCollectionViewCell
        
        guard (thisMovie.soundtracks?.count)! > 0 else { return cell }
        guard let thisSoundtrack = thisMovie.soundtracks?[indexPath.item] else { return cell }
        let thisSoundtrackAlbumImage = thisSoundtrack.images[0]
        
        
        if thisSoundtrackAlbumImage.imageData == nil {
            APIManager.manager.getData(endPoint: thisSoundtrackAlbumImage.urlString) { (data: Data?) in
                guard let unwrappedData = data else { return }
                thisSoundtrackAlbumImage.imageData = unwrappedData
                DispatchQueue.main.async {
                    cell.soundtrackImageView?.image = UIImage(data: unwrappedData)
                    cell.setNeedsLayout()
                }
            }
        } else {
            cell.soundtrackImageView?.image = UIImage(data: thisSoundtrackAlbumImage.imageData!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        // index path of the cell is unpredictable doesn't match the index of the sountrack array
        let thisSoundtrack = thisMovie.soundtracks?[indexPath.item]
        print("----------------- index path item \(indexPath.item)")
        print("----------------- index path row \(indexPath.row)")
        print("----------------- \(thisMovie.soundtracks?[0].title)")

        dump(thisSoundtrack)
        
        performSegue(withIdentifier: soundtrackDetailSegue, sender: thisSoundtrack)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == soundtrackDetailSegue {
            let destinationViewController = segue.destination as! SoundtrackDetailViewController
            let thisSoundtrack = sender as! Soundtrack
            destinationViewController.thisSoundtrack = thisSoundtrack
        }
    }
    
        
    // MARK: UICollectionViewDelegate
    
    private let itemsPerColumn = CGFloat(1)
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerColumn + 1)
        let availableHeight = collectionView.frame.height - paddingSpace
        let heightPerItem = availableHeight / itemsPerColumn
        
        return CGSize(width: heightPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

}




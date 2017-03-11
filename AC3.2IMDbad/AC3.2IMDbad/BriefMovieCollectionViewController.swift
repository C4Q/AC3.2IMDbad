//
//  BriefMovieCollectionViewController.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/9/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class BriefMovieCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UISearchBarDelegate {
    
    let briefMovieAPIEndpoint = "https://www.omdbapi.com/?s="
    
    var searchController: UISearchController!
    
    var searchWord = "batman"
    
    let fullMovieAPIEndpoint =  "https://www.omdbapi.com/?i="
    let fullMovieDetailSegue =  "fullMovieDetailSegue"
    
    private let BriefMovieReuseIdentifier = "BriefMovieCell"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        createSearchBar()
        
    }
    

    func loadData() {
        APIManager.manager.getData(endPoint: briefMovieAPIEndpoint + searchWord) { (data: Data?) in
            guard let unwrappedData = data else { return }
            if let theseMovies = Movie.buildMovieArray(from: unwrappedData) {
                self.movies = theseMovies
            } else {
                self.movies = [Movie]()
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    // originally had a logo in the nav bar but replaced it with a search bar
    func createLogo() {
        let myNicelLogoWidth = 150
        let myNiceLogoHeight = 50 //start positioning your logo at 0.0, 0.0
        let imageView = UIImageView(frame: CGRect(x: 200, y: 50, width: myNicelLogoWidth, height: myNiceLogoHeight))
        imageView.contentMode = .scaleAspectFit
        //imageView.center = navigationController?.center //the put your image at the center
        let image = UIImage(named: "logo4.jpg")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 60, width: self.view.bounds.width, height: 70)
        searchBar.barStyle = UIBarStyle.default
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.isTranslucent = true
        searchBar.showsCancelButton = false
        searchBar.showsSearchResultsButton = false
        searchBar.placeholder = "Enter a movie to search"
        searchBar.delegate = self
        searchBar.barTintColor = UIColor(red: 130/255, green: 0/255, blue: 13/255, alpha: 1.0) /* #82000d */
        searchBar.resignFirstResponder()
        self.navigationItem.titleView = searchBar
    }
    
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let allTextFieldText = searchText
        self.searchWord = allTextFieldText.replacingOccurrences(of: " ", with: "%20")
        loadData()
        
    }
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        let allTextFieldText = searchText
        self.searchWord = (allTextFieldText?.replacingOccurrences(of: " ", with: "%20"))!
        loadData()
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.BriefMovieReuseIdentifier, for: indexPath) as! BriefMovieCollectionViewCell
        let thisMovie = movies[indexPath.item]
        cell.briefMovieImageView.image = #imageLiteral(resourceName: "noAvailableImage")
        cell.briefMovieTextLabel.text = "\(thisMovie.briefInfo.title)\n\(thisMovie.briefInfo.year)"
        
        APIManager.manager.getData(endPoint: thisMovie.briefInfo.poster) { (data: Data?) in
            guard let unwrappedData = data else { return }
            DispatchQueue.main.async {
                cell.briefMovieImageView?.image = UIImage(data: unwrappedData)
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let thisMovie = movies[indexPath.item]
        performSegue(withIdentifier: fullMovieDetailSegue, sender: thisMovie)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == fullMovieDetailSegue {
            let destinationViewController = segue.destination as! FullMovieDetailViewController
            let thisMovie = sender as! Movie
            destinationViewController.thisMovie = thisMovie
            
        }
    }


    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    

}

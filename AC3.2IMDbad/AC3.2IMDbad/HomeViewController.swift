//
//  HomeViewController.swift
//  AC3.2IMDbad
//
//  Created by Simone on 11/12/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {
    
    let briefMovieAPIEndpoint = "https://www.omdbapi.com/?s="
    let fullMovieAPIEndpoint =  "https://www.omdbapi.com/?i="
    var searchWord = "batman"

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var sampleCollectionView: UICollectionView!
    
    var briefMovies = [BriefMovie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        createSearchBar()
        createLogo()

        self.sampleCollectionView.backgroundView = nil
        self.sampleCollectionView.backgroundColor = UIColor.clear
        
    }
    
    func createLogo() {
        let logoWidth = 150
        let logoHeight = 50
        let imageView = UIImageView(frame: CGRect(x: 200, y: 50, width: logoWidth, height: logoHeight))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo4.jpg")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }

    func createSearchBar() {
        
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 20, y: 20, width: self.view.bounds.width - 40, height: 70)
        searchBar.barStyle = UIBarStyle.default
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.isTranslucent = false
        searchBar.showsCancelButton = false
        searchBar.showsSearchResultsButton = false
        searchBar.placeholder = "Enter a movie to search"
        searchBar.delegate = self
        searchBar.barTintColor = UIColor(red: 130/255, green: 0/255, blue: 13/255, alpha: 1.0) /* #82000d */
        searchBar.resignFirstResponder()

        self.view.addSubview(searchBar)
        
        
    }

    func loadData() {
        
        APIManager.manager.getData(endPoint: briefMovieAPIEndpoint + searchWord) { (data: Data?) in
            guard let unwrappedData = data else { return }
            self.briefMovies = BriefMovie.buildBriefMovieArray(from: unwrappedData)!
            DispatchQueue.main.async {
                self.sampleCollectionView?.reloadData()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return briefMovies.count
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCell", for: indexPath) as! HomeCollectionViewCell
        cell.backgroundColor = UIColor.clear
        let title = self.briefMovies[indexPath.item]
        cell.briefMovie = title
        
        
        return cell
    }
    
}

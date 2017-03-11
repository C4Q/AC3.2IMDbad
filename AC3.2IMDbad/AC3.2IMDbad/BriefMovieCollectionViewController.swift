//
//  BriefMovieCollectionViewController.swift
//  AC3.2IMDbad
//
//  Created by Tom Seymour on 11/9/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit



class BriefMovieCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let briefMovieAPIEndpoint = "https://www.omdbapi.com/?s="
    var searchWord = "batman"
    
    let fullMovieAPIEndpoint =  "https://www.omdbapi.com/?i="
    let fullMovieDetailSegue =  "fullMovieDetailSegue"
    
    private let BriefMovieReuseIdentifier = "BriefMovieCell"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var briefMovies = [BriefMovie]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backButton")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButton")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    
    }
    
    func loadData() {
        
        APIManager.manager.getData(endPoint: briefMovieAPIEndpoint + searchWord) { (data: Data?) in
            guard let unwrappedData = data else { return }
            self.briefMovies = BriefMovie.buildBriefMovieArray(from: unwrappedData)!
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let allTextFieldText = textField.text ?? "batman"
        textField.text = nil
        self.searchWord = allTextFieldText.replacingOccurrences(of: " ", with: "%20")
        
        loadData()
        
        return true
    }




    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return briefMovies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.BriefMovieReuseIdentifier, for: indexPath) as! BriefMovieCollectionViewCell
        let thisBriefMovie = briefMovies[indexPath.item]

        cell.briefMovieTextLabel.text = "\(thisBriefMovie.title)\n\(thisBriefMovie.year)"
        
        APIManager.manager.getData(endPoint: thisBriefMovie.poster) { (data: Data?) in
            guard let unwrappedData = data else { return }
            DispatchQueue.main.async {
                cell.briefMovieImageView?.image = UIImage(data: unwrappedData)
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let thisBriefMovie = briefMovies[indexPath.item]
        let thisFullMovieAPIEndpoint = self.fullMovieAPIEndpoint + thisBriefMovie.imdbID
        
        APIManager.manager.getData(endPoint: thisFullMovieAPIEndpoint) { (data: Data?) in
            guard let unwrappedData = data else { return }
            let thisFullMovie = FullMovie.getFullMovie(from: unwrappedData)
            dump(thisFullMovie)
        }
        performSegue(withIdentifier: fullMovieDetailSegue, sender: thisBriefMovie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == fullMovieDetailSegue {
            let destinationViewController = segue.destination as! FullMovieDetailViewController
            let thisBriefMovie = sender as! BriefMovie
            
            destinationViewController.thisBriefMovie = thisBriefMovie
        }
    }


    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.7)
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
    
    
    
    


    
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

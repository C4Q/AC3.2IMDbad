//
//  HomeCollectionViewCell.swift
//  AC3.2IMDbad
//
//  Created by Simone on 11/12/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    var briefMovie: BriefMovie! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var featuredTitleLabel: UILabel!
    
    private func updateUI() {
        featuredTitleLabel?.text = briefMovie.title
        
        APIManager.manager.getData(endPoint: briefMovie.poster) { (data: Data?) in
            guard let unwrappedData = data else { return }
            DispatchQueue.main.async {
                self.featuredImageView?.image = UIImage(data: unwrappedData)
            }
        }
    }
}

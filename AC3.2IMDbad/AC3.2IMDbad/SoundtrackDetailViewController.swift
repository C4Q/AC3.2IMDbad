//
//  SoundtrackDetailViewController.swift
//  AC3.2IMDbad
//
//  Created by Ilmira Estil on 11/13/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class SoundtrackDetailViewController: UIViewController {
    var thisSoundtrack: Soundtrack!
    
    @IBOutlet weak var soundtrackBackgroundImage: UIImageView!
    @IBOutlet weak var soundtrackImageView: UIImageView!
    @IBOutlet weak var soundtrackTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSoundtrackData()
        
    }
    
    func loadSoundtrackData() {
        soundtrackTextLabel.text = ("Album Name: \(thisSoundtrack.title)\nby: \(thisSoundtrack.artistName)")
        
        // first checks to see if the data already exists in the class
        
        if let soundtrackImageData = thisSoundtrack.images[0].imageData {
            soundtrackImageView.image = UIImage(data: soundtrackImageData)
        }
        else {
            APIManager.manager.getData(endPoint: thisSoundtrack.images[0].urlString, callback: { (data: Data?) in
                guard let unwrappedData = data else { return }
                self.thisSoundtrack.images[0].imageData = unwrappedData
                DispatchQueue.main.async {
                    self.soundtrackImageView.image = UIImage(data: unwrappedData)
                    self.view.setNeedsLayout()
                }
            })
        }
    } 
   
}

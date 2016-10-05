//
//  ViewController.swift
//  setlist
//
//  Created by Benoit Deguine on 23/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var addNewArtist: UIBarButtonItem!
    @IBOutlet weak var collection:UICollectionView!
    @IBOutlet weak var labelArtistEmpty: UILabel!
    
    var artists = [Artists]()
    var fetchedresultsController: NSFetchedResultsController<Artists>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collection.delegate = self
        self.collection.dataSource = self
        
        navigationController!.navigationBar.barTintColor = UIColor().mainColor()
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = String(format: NSLocalizedString("my_artists", comment: "Mes artistes"))
        
        self.view.backgroundColor = UIColor().backgroundColor()
        self.addNewArtist.tintColor = UIColor().buttonColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchAndSetResults()
        self.collection.reloadData()
        
        if (self.artists.count > 0) {
            self.labelArtistEmpty.isHidden = true
            self.collection.isHidden = false
        } else {
            self.collection.isHidden = true
            self.labelArtistEmpty.text = String(format: NSLocalizedString("my_artists_empty", comment: "Aucun artiste"))
            self.labelArtistEmpty.textColor = UIColor().darkGrey()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Core Data
    func fetchAndSetResults() {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let artistsService = ArtistsService(context: context)
        
        self.artists = artistsService.getAll(order: .Alphabetique, ascending: true)
    }
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as? ArtistCollectionViewCell {
            
            cell.configureCell(Artist(name: self.artists[(indexPath as NSIndexPath).row].name!, mbid: self.artists[(indexPath as NSIndexPath).row].mbid!))
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artist = Artist(name: self.artists[(indexPath as NSIndexPath).row].name!, mbid: self.artists[(indexPath as NSIndexPath).row].mbid!)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let artistsService = ArtistsService(context: context)
        
        let myArtist = artistsService.getById(id:self.artists[(indexPath as NSIndexPath).row].objectID)
        myArtist?.countView = NSNumber(value: (myArtist?.countView?.intValue)! + 1)
        artistsService.update(updatedArtist: myArtist!)
        
        performSegue(withIdentifier: "openArtistSetlist", sender: artist)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.artists.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size:CGFloat = ((UIScreen.main.bounds.width-20)/2)-5
        
        return CGSize(width: size, height: size-15)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openArtistSetlist") {
            if let detailsVC = segue.destination as? ArtistEventsViewController {
                if let artist = sender as? Artist {
                    detailsVC.artist = artist
                }
            }
        }
    }

}


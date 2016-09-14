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
    
    var artists = [Artists]()
    var fetchedresultsController: NSFetchedResultsController<Artists>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collection.delegate = self
        self.collection.dataSource = self
        
        navigationController!.navigationBar.barTintColor = UIColor().mainColor()
        navigationController?.navigationBar.tintColor = UIColor().mainColor()
        
        self.view.backgroundColor = UIColor().backgroundColor()
        self.addNewArtist.tintColor = UIColor().buttonColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchAndSetResults()
          self.collection.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Core Data
    func fetchAndSetResults() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artists")
        
        do {
            let results = try context.fetch(fetchRequest)
            self.artists = results as! [Artists]
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as? ArtistCollectionViewCell {
            
            cell.configureCell(Artist(name: self.artists[(indexPath as NSIndexPath).row].getName(), mbid: self.artists[(indexPath as NSIndexPath).row].mbid!))
            
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artist = Artist(name: self.artists[(indexPath as NSIndexPath).row].name!, mbid: self.artists[(indexPath as NSIndexPath).row].mbid!)
        
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


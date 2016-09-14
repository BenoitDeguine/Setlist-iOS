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
    var fetchedresultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collection.delegate = self
        self.collection.dataSource = self
        
        navigationController!.navigationBar.barTintColor = UIColor().mainColor()
        navigationController?.navigationBar.tintColor = UIColor().mainColor()
        
        self.view.backgroundColor = UIColor().backgroundColor()
        self.addNewArtist.tintColor = UIColor().buttonColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.fetchAndSetResults()
          self.collection.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Core Data
    func fetchAndSetResults() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Artists")
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.artists = results as! [Artists]
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // MARK: - UICollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("artistCell", forIndexPath: indexPath) as? ArtistCollectionViewCell {
            
            cell.configureCell(Artist(name: self.artists[indexPath.row].getName(), mbid: self.artists[indexPath.row].mbid!))
            
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let artist = Artist(name: self.artists[indexPath.row].name!, mbid: self.artists[indexPath.row].mbid!)
        
        performSegueWithIdentifier("openArtistSetlist", sender: artist)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.artists.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size:CGFloat = ((UIScreen.mainScreen().bounds.width-20)/2)-5
        
        return CGSizeMake(size, size-15)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "openArtistSetlist") {
            if let detailsVC = segue.destinationViewController as? ArtistEventsViewController {
                if let artist = sender as? Artist {
                    detailsVC.artist = artist
                }
            }
        }
    }
}


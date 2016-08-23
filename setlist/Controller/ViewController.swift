//
//  ViewController.swift
//  setlist
//
//  Created by Benoit Deguine on 23/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var addNewArtist: UIBarButtonItem!
    
    var artists = [Artists]()
    var fetchedresultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor().mainColor()
        self.view.backgroundColor = UIColor().backgroundColor()
        self.addNewArtist.tintColor = UIColor().buttonColor()
        self.fetchAndSetResults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    // MARK: - Core Data
    func fetchAndSetResults() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName :  "Artists")
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.artists = results as! [Artists]
            
            print(self.artists)
             print(self.artists.count)
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

}


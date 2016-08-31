//
//  AddArtistViewController.swift
//  setlist
//
//  Created by Benoit Deguine on 30/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class AddArtistViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var imageArtist: UIImageView!
    @IBOutlet weak var titleArtist: UILabel!
    @IBOutlet weak var textArtist: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var myArtist = Artist()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchArtistImage()
        
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = false
        
        imageArtist.layer.cornerRadius = 8
        imageArtist.layer.masksToBounds = true
        
        // Texte
        self.textArtist.text = String(format: NSLocalizedString("add_artist_to_library", comment: ""), myArtist.name)
        self.titleArtist.text = myArtist.name
        
        // Bouton fermer
        self.closeButton.backgroundColor = UIColor().buttonColor()
        self.closeButton.tintColor = UIColor().mainColor()
        self.closeButton.layer.cornerRadius = 5
        self.closeButton.layer.masksToBounds = true
        self.closeButton.layer.borderColor = UIColor().mainColor().CGColor
        self.closeButton.layer.borderWidth = 1
        self.closeButton.setTitle(String(format: NSLocalizedString("add_artist_to_library_no", comment: "Ne pas ajouter l'artiste")), forState: .Normal)
        self.closeButton.setTitleColor(UIColor().mainColor(), forState: .Normal)
        
        // Bouton Ajouter
        self.addButton.backgroundColor = UIColor().mainColor()
        self.addButton.tintColor = UIColor().buttonColor()
        self.addButton.layer.cornerRadius = 5
        self.addButton.layer.masksToBounds = true
        self.addButton.layer.borderColor = UIColor().mainColor().CGColor
        self.addButton.layer.borderWidth = 1
        self.addButton.setTitle(String(format: NSLocalizedString("add_artist_to_library_yes", comment: "Ajout de l'artist")), forState: .Normal)
    }
    
    
    //MARK: - Core Data
    func searchArtistImage() {
        
        if (myArtist.mbid != "") {
            // On va chercher sur Spotify l'image du groupe
            var url:String = "https://api.spotify.com/v1/search?q=" +  myArtist.name as String + "&type=artist&limit=1"
            print(url)
            url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            Alamofire.request(.GET, url, parameters: [:])
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        print(response)
                        let response = response.result.value as! NSDictionary
                        let res = response.objectForKey("artists")!  as! NSDictionary
                        let items = res.objectForKey("items")!  as! NSArray
                        let images = items.firstObject?.objectForKey("images")! as! NSArray
                        
                        self.myArtist.thumbnails = images.firstObject?.objectForKey("url") as! String
                        
                        if let url = NSURL(string: self.myArtist.thumbnails) {
                            if let data = NSData(contentsOfURL: url) {
                                self.imageArtist.image = UIImage(data: data)
                            }
                        }
                        print(self.myArtist.thumbnails)
                        self.imageArtist.image = self.myArtist.getImage()
                        
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    @IBAction func addArtist(sender: AnyObject) {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let entity = NSEntityDescription.entityForName("Artists", inManagedObjectContext: context)
        
        let artist = Artists(entity: entity!, insertIntoManagedObjectContext: context)
        artist.name = self.myArtist.name
        artist.mbid = self.myArtist.mbid
        artist.image = self.myArtist.thumbnails
        artist.dateAdd = NSDate()
        
        context.insertObject(artist)
        
        do {
            try context.save()
            print("ok")
        } catch {
            print("Error d'enregistrement")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

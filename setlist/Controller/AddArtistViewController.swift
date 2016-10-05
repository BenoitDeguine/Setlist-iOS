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
    
    @IBOutlet weak var labelLoading: UILabel!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    var myArtist:Artist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchArtistImage()
        
        self.backgroundView.alpha = 0
        
        self.backgroundView.layer.cornerRadius = 10
        self.backgroundView.layer.masksToBounds = false
        
        self.imageArtist.layer.cornerRadius = 8
        self.imageArtist.layer.masksToBounds = true
        self.imageArtist.backgroundColor = UIColor().mainColor()
        
        self.navigationController?.navigationBar.setBottomBorderColor(UIColor().mainColor(), height: 1)
        
        // Texte
        self.textArtist.text = String(format: NSLocalizedString("add_artist_to_library", comment: ""), myArtist.name)
        self.titleArtist.text = myArtist.name
        
        // Bouton fermer
        self.closeButton.backgroundColor = UIColor().buttonColor()
        self.closeButton.tintColor = UIColor().mainColor()
        self.closeButton.layer.cornerRadius = 5
        self.closeButton.layer.masksToBounds = true
        self.closeButton.layer.borderColor = UIColor().mainColor().cgColor
        self.closeButton.layer.borderWidth = 1
        self.closeButton.setTitle(String(format: NSLocalizedString("add_artist_to_library_no", comment: "Ne pas ajouter l'artiste")), for: UIControlState())
        self.closeButton.setTitleColor(UIColor().mainColor(), for: UIControlState())
        
        // Bouton Ajouter
        self.addButton.backgroundColor = UIColor().mainColor()
        self.addButton.tintColor = UIColor().buttonColor()
        self.addButton.layer.cornerRadius = 5
        self.addButton.layer.masksToBounds = true
        self.addButton.layer.borderColor = UIColor().mainColor().cgColor
        self.addButton.layer.borderWidth = 1
        self.addButton.setTitle(String(format: NSLocalizedString("add_artist_to_library_yes", comment: "Ajout de l'artist")), for: UIControlState())
        
        self.labelLoading.textColor = UIColor().buttonColor()
        self.labelLoading.text = NSLocalizedString("add_artist_loading_image", comment: "Chargement de l'image")
        self.activityLoader.tintColor = UIColor().buttonColor()
        
        UIView.animate(withDuration: 1, animations: {
            self.backgroundView.alpha = 1.0
        })
    }
    
    
    //MARK: - Core Data
    func searchArtistImage() {
        
        if (myArtist.mbid != "") {
            // On va chercher sur Spotify l'image du groupe
            var url:String = App.URL.spotify + "search?q=" +  myArtist.name as String + "&type=artist&limit=2"
            print(url)
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            Alamofire.request(url, method: .get).responseJSON { response in
                switch response.result {
                case .success:
                    print(response)
                    self.labelLoading.isHidden = true
                    self.activityLoader.isHidden = true
                    let response = response.result.value as! NSDictionary
                    let res = response.object(forKey: "artists")! as! NSDictionary
                    let items = res.object(forKey: "items")! as! NSArray
                    
                    // S'il y a un résultat, alors on enregistre
                    if (items.count > 0) {
                        let images = (items[0] as AnyObject)
                        let imagesArr = images.object(forKey: "images") as! NSArray
                        
                        if (imagesArr.count > 0) {
                            self.myArtist.thumbnails = (imagesArr[0] as AnyObject).object(forKey: "url") as! String
                            
                            DispatchQueue.global().async {
                                if let url = NSURL(string: self.myArtist.thumbnails) {
                                    DispatchQueue.main.async {
                                        if let data = NSData(contentsOf: url as URL) {
                                            self.imageArtist.image = UIImage(data: data as Data)
                                        }
                                    };
                                }
                                self.imageArtist.image = self.myArtist.getImage()
                            }
                        } else {
                            self.imageArtist.image = UIImage(named: "anonymousBand") 
                        }
                    } else {
                        self.imageArtist.image = UIImage(named: "anonymousBand")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func addArtist(_ sender: AnyObject) {
        
        UIImage().saveImageFromUIImage(self.myArtist.mbid, myImageToSave: self.imageArtist.image!)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let artistsService = ArtistsService(context: context)
        
        artistsService.create(artist: self.myArtist)
        
        self.closeViewController()
    }
    
    @IBAction func closeButton(_ sender: AnyObject) {
        self.closeViewController()
    }
    
    func closeViewController() {
        self.dismiss(animated: false, completion: {});
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

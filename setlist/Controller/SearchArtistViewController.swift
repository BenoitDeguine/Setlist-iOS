//
//  SearchArtistViewController.swift
//  setlist
//
//  Created by Benoit Deguine on 23/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class SearchArtistViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var artistsSearch = [Artist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor().mainColor()
        self.view.backgroundColor = UIColor().backgroundColor()
        
        self.navigationController?.navigationBar.setBottomBorderColor(UIColor().mainColor(), height: 1)
        
        searchBar.translucent = false
        searchBar.backgroundColor = UIColor().mainColor()
        searchBar.barTintColor = UIColor().mainColor()
        searchBar.userInteractionEnabled = true
        
        self.closeButton.tintColor = UIColor().buttonColor()
        
        self.setFocusOnBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
    
    func setFocusOnBar() {
        self.searchBar.becomeFirstResponder()
    }
    
    
    // MARK: - UISearch
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        var url:String = "http://musicbrainz.org/ws/2/artist/?query=artist:" +  searchBar.text! as String + "&fmt=json"
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        Alamofire.request(.GET, url, parameters: [:])
            .responseJSON { response in
                switch response.result {
                case .Success:                    
                    let response = response.result.value as! NSDictionary
                    let res = response.objectForKey("artists")!  as! NSArray
                    let nombre:Int = response.objectForKey("count") as! Int
                    
                    self.artistsSearch.removeAll()
                    
                    for i in res {
                        var disambiguation:String = ""
                        if (i.objectForKey("disambiguation") != nil) {
                            disambiguation = i.objectForKey("disambiguation") as! String
                        }
                        self.artistsSearch.append(Artist(name: i.objectForKey("name") as! String, mbid: i.objectForKey("id") as! String, disambiguation:disambiguation))
                    }
                    self.tableView.reloadData()
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    // Mark: - Tableview Protocols
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artistsSearch.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (self.artistsSearch[indexPath.row].disambiguation == "") {
            let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            cell.textLabel?.text = self.artistsSearch[indexPath.row].name
            return cell
        } else {
            let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cellWithDisambiguation")! as UITableViewCell
            cell.textLabel?.text = self.artistsSearch[indexPath.row].name
            cell.detailTextLabel!.text = self.artistsSearch[indexPath.row].disambiguation
            
            return cell
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      self.addArtist(self.artistsSearch[indexPath.row])
    }
    
    //MARK: - Core Data
    func addArtist(myArtist:Artist) {
    
        if (myArtist.mbid != "") {
            
            // On va chercher sur Spotify l'image du groupe
            var url:String = "https://api.spotify.com/v1/search?q=" +  myArtist.name as String + "&type=artist&limit=1"
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
                        
                        let app = UIApplication.sharedApplication().delegate as! AppDelegate
                        let context = app.managedObjectContext
                        let entity = NSEntityDescription.entityForName("Artists", inManagedObjectContext: context)
                        
                        let artist = Artists(entity: entity!, insertIntoManagedObjectContext: context)
                        artist.name = myArtist.name
                        artist.mbid = myArtist.mbid
                        artist.image = images.firstObject?.objectForKey("url") as! String
                        artist.dateAdd = NSDate()
                        
                        context.insertObject(artist)
                        
                        do {
                            try context.save()
                            print("ok")
                        } catch {
                            print("Error d'enregistrement")
                        }
                        
                    case .Failure(let error):
                        print(error)
                    }
            }
            
            
        }
    
    }
    
}

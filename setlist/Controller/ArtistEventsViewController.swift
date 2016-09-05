//
//  ArtistEventsViewController.swift
//  Setlist
//
//  Created by Benoit Deguine on 03/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit
import Alamofire

class ArtistEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var artist:Artist!
    var events = [Event]()
    var totalEvents:Int = 0
    
    @IBOutlet weak var artistEvents: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.artistEvents.delegate = self
        self.artistEvents.dataSource = self
        
        self.view.backgroundColor = UIColor().backgroundColor()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        var url:String = App.URL.setlistfm + "artist/" +  artist.mbid + "/setlists.json"
        print(url)
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        Alamofire.request(.GET, url, parameters: [:])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let response = response.result.value as! NSDictionary
                    let res = response.objectForKey("setlists")!  as! NSDictionary
                    self.totalEvents = Int(res.objectForKey("@total") as! String)!
                    
                    let setlists = res.objectForKey("setlist") as! NSArray
                    print(setlists.count)
                    
                    if (setlists.count > 0) {
                        for i in setlists {
                            self.events.append(Event(value: i as! NSDictionary))
                        }
                    }
                    
                    self.artistEvents.reloadData()
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: - Tableview Protocols
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      print(self.events.count)
        return self.events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("artistEventCell")! as! ArtistEventsCell
        print(self.events[indexPath.row].venue.name)
            cell.textLabel?.text = self.events[indexPath.row].date
            cell.detailTextLabel!.text = self.events[indexPath.row].venue.name + ", " + self.events[indexPath.row].venue.cityName
 
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // On ouvre le segue
     //   self.performSegueWithIdentifier("addArtist", sender: self.artistsSearch[indexPath.row])
    }


}

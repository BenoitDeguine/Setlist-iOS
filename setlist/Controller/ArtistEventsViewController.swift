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
    var events = Array<Array<Event>>()
    var eventsSection = [String]()
    var totalEvents:Int = 0
    var pageNumber:Int = 1
    
    var tableviewScrollToBottom:Bool = true
    var lastContentOffset:CGFloat = CGFloat()
    
    @IBOutlet weak var artistEvents: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.artistEvents.delegate = self
        self.artistEvents.dataSource = self
        
        self.view.backgroundColor = UIColor().backgroundColor()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        var url:String = App.URL.setlistfm + "artist/" +  artist.mbid + "/setlists.json?&l=" + User.language + "&p=" + String(pageNumber)
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
                    
                    if (setlists.count > 0) {
                        for i in setlists {
                            var event:Event = Event(value: i as! NSDictionary)
                            let res:Int = self.addInSection(event.getDateMMYYYY())
                            self.events[res].append(event)
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
        return self.events[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ArtistEventsCell = tableView.dequeueReusableCellWithIdentifier("artistEventCell")! as! ArtistEventsCell
        
        cell.dayLabel.text = self.events[indexPath.section][indexPath.row].getDateDD()
        cell.titleLabel.text = self.events[indexPath.section][indexPath.row].venue.getVenueName()
        cell.addressLabel.text = self.events[indexPath.section][indexPath.row].venue.getVenueAddress()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    // MARK: - Table view section
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.eventsSection[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.eventsSection.count
    }
    
    // Mark: - Effect sur la tableview lors du scrol
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (self.lastContentOffset != 0) {
            view.alpha = 0
            
            var valueEffect:CGFloat = 0
            
            if (self.tableviewScrollToBottom) {
                valueEffect = 250
            } else {
                valueEffect = -250
            }
            
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, valueEffect, 0)
            view.layer.transform = transform
            
            UIView.animateWithDuration(0.5) {
                view.alpha = 1.0
                view.layer.transform = CATransform3DIdentity
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (self.lastContentOffset != 0) {
            cell.alpha = 0
            
            var valueEffect:CGFloat = 0
            
            if (self.tableviewScrollToBottom) {
                valueEffect = 250
            } else {
                valueEffect = -250
            }
            
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, valueEffect, 0)
            cell.layer.transform = transform
            
            UIView.animateWithDuration(0.5) {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var currentOffset = scrollView.contentOffset
        
        if (currentOffset.y > self.lastContentOffset) {
            if (!self.tableviewScrollToBottom) {
                self.tableviewScrollToBottom = true
            }
        } else {
            if (self.tableviewScrollToBottom) {
                self.tableviewScrollToBottom = false
            }
        }
        self.lastContentOffset = currentOffset.y
    }

    
    // Mark: - Array
    func addInSection(text:String)->Int {
        if (!self.eventsSection.contains(text)) {
            self.eventsSection.append(text)
            self.events.append([])
        }
        return self.eventsSection.indexOf(text)!
    }
    
}

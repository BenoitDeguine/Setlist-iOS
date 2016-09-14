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
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    var artist:Artist!
    var events = Array<Array<Event>>()
    var eventsSection = [String]()
    var totalEvents:Int = 0
    var pageNumber:Int = 0
    var searchNewSetlist:Bool = false
    
    var tableviewScrollToBottom:Bool = true
    var lastContentOffset:CGFloat = CGFloat()
    
    var tableViewEffetInsertRow:Bool = false
    
    @IBOutlet weak var artistEvents: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.artistEvents.delegate = self
        self.artistEvents.dataSource = self
        
        self.navigationController?.navigationBar.setBottomBorderColor(UIColor().mainColor(), height: 1)
        
        self.view.backgroundColor = UIColor().backgroundColor()
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        self.searchSetlist()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // API SetlistFM
    func searchSetlist() {
        self.pageNumber = self.pageNumber + 1
        var url:String = App.URL.setlistfm + "artist/" +  artist.mbid + "/setlists.json?&l=" + User.language + "&p=" + String(pageNumber)
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                
                switch response.result {
                    
                case .success:
                    let response = response.result.value as! NSDictionary
                    let res = response.object(forKey: "setlists")!  as! NSDictionary
                    self.totalEvents = Int(res.object(forKey: "@total") as! String)!
                    
                    let setlists = res.object(forKey: "setlist") as! NSArray
                    
                    if (setlists.count > 0) {
                        print(setlists)
                        
                        for i in setlists {
                            let event:Event = Event(value: i as! NSDictionary)
                            let res:Int = self.addInSection(event.getDateMMYYYY())
                            self.events[res].append(event)
                        }
                    }
                    
                    // Pour savoir si on joue l'effet sur les cell
                    self.tableViewEffetInsertRow = false
                    self.artistEvents.reloadData({
                        self.tableViewEffetInsertRow = true
                    })
                    
                case .failure(let error):
                    print(error)
                }
        }
        
    }
    
    // Mark: - Tableview Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ArtistEventsCell = tableView.dequeueReusableCell(withIdentifier: "artistEventCell")! as! ArtistEventsCell
        
        cell.dayLabel.text = self.events[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].getDateDD()
        cell.titleLabel.text = self.events[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].venue.getVenueName()
        cell.addressLabel.text = self.events[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].venue.getVenueAddress()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("---------")
        let event:Event = self.events[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        print(event.venue.name)
        print(event.sets.count)
        print(event.sets.first?.song)
        print(event.sets.first?.song.first?.name)
        
        performSegue(withIdentifier: "openSetlist", sender: event)
    }
    
    // MARK: - Table view section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.eventsSection[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.eventsSection.count
    }
    
    // Mark: - Effect sur la tableview lors du scroll
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (self.lastContentOffset != 0  && tableViewEffetInsertRow) {
            view.alpha = 0
            
            var valueEffect:CGFloat = 0
            
            if (self.tableviewScrollToBottom) {
                valueEffect = 250
            } else {
                valueEffect = -250
            }
            
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, valueEffect, 0)
            view.layer.transform = transform
            
            UIView.animate(withDuration: 0.5, animations: {
                view.alpha = 1.0
                view.layer.transform = CATransform3DIdentity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (self.lastContentOffset != 0 && tableViewEffetInsertRow) {
            cell.alpha = 0
            
            var valueEffect:CGFloat = 0
            
            if (self.tableviewScrollToBottom) {
                valueEffect = 250
            } else {
                valueEffect = -250
            }
            
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, valueEffect, 0)
            cell.layer.transform = transform
            
            UIView.animate(withDuration: 0.5, animations: {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            })
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Savoir si l'utilisater scroll vers le bas ou vers le haut
        let currentOffset = scrollView.contentOffset
        
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
        
        // Infinite scroll
        let currentOffsetScroll = scrollView.contentOffset.y
        let maximumOffsetScroll = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffsetScroll - currentOffsetScroll) <= 100 {
            if (!self.searchNewSetlist) {
                self.searchSetlist()
                self.searchNewSetlist = true
            }
        } else {
            self.searchNewSetlist = false
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewHeader") as! SectionTableViewHeader
        cell.backgroundColor = UIColor().mainColor()
        cell.title.textColor = UIColor().buttonColor()
        
        var fullDate = self.eventsSection[section].characters.split{$0 == "-"}.map(String.init)
        cell.title.text = String(stringInterpolation: Date().getDateFromNumber(fullDate[0]), " ", fullDate[1])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    // Mark: - Array
    func addInSection(_ text:String)->Int {
        if (!self.eventsSection.contains(text)) {
            self.eventsSection.append(text)
            self.events.append([])
        }
        return self.eventsSection.index(of: text)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openSetlist") {
            if let detailsVC = segue.destination as? ShowSetlistViewController {
                if let myEvent = sender as? Event {
                    detailsVC.event = myEvent
                    detailsVC.imageBackground = UIImage().takeScreenshoot(self.view)
                    detailsVC.artist = self.artist
                }
            }
        }
    }
    
}

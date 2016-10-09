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
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var animateLoader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.artistEvents.delegate = self
        self.artistEvents.dataSource = self
        
        self.artistEvents.isHidden = true
        
        self.navigationController?.navigationBar.setBottomBorderColor(UIColor().mainColor(), height: 1)
        
        self.view.backgroundColor = UIColor().backgroundColor()
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        artistEvents.rowHeight = UITableViewAutomaticDimension
        artistEvents.estimatedRowHeight = 200.0
        
        self.searchSetlist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GoogleAnalytics().sendScreenView(name: "Dates d'un artiste")
        GoogleAnalytics().trackAction(category: "VOIR_CONCERTS_ARTISTE", action: self.artist.name)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // API SetlistFM
    func searchSetlist() {
        
        self.labelMessage.text = String(format: NSLocalizedString("set_last", comment: "Les dernières dates du groupe"),artist.name)
        self.labelMessage.textColor = UIColor().darkGrey()
        self.animateLoader.isHidden = false
        
        self.pageNumber = self.pageNumber + 1
        var url:String = App.URL.setlistfm + "artist/" +  artist.mbid + "/setlists.json?&l=" + User.language + "&p=" + String(pageNumber)
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    
                    self.artistEvents.isHidden = false
                    self.labelMessage.isHidden = true
                    self.animateLoader.isHidden = true
                    
                    let response = response.result.value as! NSDictionary
                    let res = response.object(forKey: "setlists")!  as! NSDictionary
                    self.totalEvents = Int(res.object(forKey: "@total") as! String)!
                    
                    var setlists = [NSDictionary]()
                    // On verifie que l'objet est un array
                    if (res.object(forKey: "setlist") as! NSObject) is NSDictionary {
                        setlists.append(res.object(forKey: "setlist") as! NSDictionary)
                    } else {
                        setlists = (res.object(forKey: "setlist") as! NSArray) as! [NSDictionary]
                    }
                    
                    if (setlists.count > 0) {
                        print(setlists)
                        for i in setlists {
                            let event:Event = Event(value: i)
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
                    self.labelMessage.text = NSLocalizedString("set_last_none", comment: "Les dernières dates du groupe")
                    self.animateLoader.isHidden = true
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
        
        if (self.events[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].numberSongs == 0) {
            print(self.events[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].numberSongs)
            cell.titleLabel.textColor = UIColor().setlistUnavailable()
            cell.dayLabel.textColor = UIColor().setlistUnavailable()
            cell.addressLabel.textColor = UIColor().setlistUnavailable()
        } else {
            cell.titleLabel.textColor = UIColor.black
            cell.dayLabel.textColor = UIColor.black
            cell.addressLabel.textColor = UIColor.black
        }
        
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
        self.artistEvents.deselectRow(at: indexPath, animated: true)
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
        if (self.lastContentOffset != 0 && tableViewEffetInsertRow) {
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

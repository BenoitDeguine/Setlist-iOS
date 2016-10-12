//
//  ShowSetlistViewController.swift
//  Setlist
//
//  Created by Benoit Deguine on 09/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class ShowSetlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var event:Event!
    var artist:Artist!
    var imageBackground:UIImage = UIImage()
    
    @IBOutlet weak var imageClose: UIImageView!
    @IBOutlet weak var tableViewSetlist: UITableView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: self.imageBackground)
        self.tableViewSetlist.backgroundColor = UIColor.clear
        self.imageClose.tintColor = UIColor.white
        
        // Pour fermer la fenêtre lors d'un clic sur l'image
        let tap = UITapGestureRecognizer(target: self, action: #selector(ShowSetlistViewController.closeWindows))
        imageClose.addGestureRecognizer(tap)
        imageClose.isUserInteractionEnabled = true
        
        self.tableViewSetlist.rowHeight = UITableViewAutomaticDimension
        self.tableViewSetlist.estimatedRowHeight = 55.0
        
        var numberOfSong = 1
        for e in event.sets {
            for song in e.song {
                if (!song.isTape) {
                    song.number = numberOfSong
                    numberOfSong += 1
                }
            }
        }
        
        if (self.event.numberSongs == 0) {
            self.tableViewSetlist.isHidden = true
            self.label.isHidden = false
            self.label.text = String(format: NSLocalizedString("set_not_available", comment: "Setlist non disponible"))
            self.label.textColor = UIColor().buttonColor()
        } else {
            self.label.isHidden = true
             self.tableViewSetlist.isHidden = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GoogleAnalytics().sendScreenView(name: "Setlist d'un artiste")
        GoogleAnalytics().trackAction(category: "SETLIST_ARTISTE", action: self.artist.name, label: self.event.getAnalyticsName())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Mark: - Tableview Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.event.sets[section].song.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.event.sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].isTape == true) {
            
            if (self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].artistName == nil && self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].info == nil) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "setlistCellTapeWithoutInfo")! as! SetlistCellTapeWithoutInfo
                cell.title.text = self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].name as String
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "setlistCellTape")! as! SetlistCellTape
                cell.title.text = self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].name as String
                
                if (self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].artistName != nil) {
                    cell.info.text = self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].artistName as String
                } else if (self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].info != "") {
                    cell.info.text = self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].info
                }
                return cell
            }
            
        }  else if (self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].isCover == true) {
            let cell:SetlistCellWithInfo = tableView.dequeueReusableCell(withIdentifier: "setlistCellWithInfo")! as! SetlistCellWithInfo
            cell.title.text = self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].name as String
            
            print(self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].artistName)
            cell.info.text = self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].artistName + " Cover"
            cell.labelNumber.text = String(self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].number) + "."
            cell.labelNumber.textColor = UIColor().darkGrey()
            
            return cell
        } else if (self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].info == nil) {
            let cell:SetlistCell = tableView.dequeueReusableCell(withIdentifier: "setlistCell")! as! SetlistCell
            cell.title.text = self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].name as String
            cell.labelNumber.text = String(self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].number) + "."
            cell.labelNumber.textColor = UIColor().darkGrey()
            
            return cell
        } else {
            let cell:SetlistCellWithInfo = tableView.dequeueReusableCell(withIdentifier: "setlistCellWithInfo")! as! SetlistCellWithInfo
            cell.title.text = self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].name as String
            cell.info.text = self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].info as String
            
            cell.labelNumber.text = String(self.event.sets[(indexPath as NSIndexPath).section].song[(indexPath as NSIndexPath).row].number) + "."
            cell.labelNumber.textColor = UIColor().darkGrey()
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerSection") as! SetlistHeaderSectionTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.title.textColor = UIColor().buttonColor()
        
        // S'il y a plusieurs Encore, on affichera "Encore 1", "Encore 2", ...
        if (self.event.sets[section].isEncore && ((section+1) != self.event.sets.count)) {
            cell.title.text = "Encore " + self.event.sets[section].name
        } else if (self.event.sets[section].isEncore) { // S'il y en a qu'un on affichera uniquement "Encore"
            if (self.event.sets[section].name.characters.count > 1) {
                cell.title.text = self.event.sets[section].name
            } else {
                cell.title.text = "Encore"
            }
        } else { // Sinon le nom du Set récupéré de setlist.fm
            cell.title.text = self.event.sets[section].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.event.sets[section].name == "") {
            return 15
        } else {
            return 65
        }
    }
    
    // Effect cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.75, animations: {
            cell.alpha = 1.0
        })
    }
    
    func closeWindows() {
        self.dismiss(animated: true, completion: {});
    }
    
}

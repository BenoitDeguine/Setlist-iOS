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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: self.imageBackground)
        self.imageClose.tintColor = UIColor.whiteColor()
        
        // Pour fermer la fenêtre lors d'un clic sur la fenêtre
        let tap = UITapGestureRecognizer(target: self, action: #selector(ShowSetlistViewController.closeWindows))
        imageClose.addGestureRecognizer(tap)
        imageClose.userInteractionEnabled = true
        
        self.tableViewSetlist.rowHeight = UITableViewAutomaticDimension
        self.tableViewSetlist.estimatedRowHeight = 55.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Mark: - Tableview Protocols
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.event.sets[section].song.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.event.sets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (self.event.sets[indexPath.section].song[indexPath.row].isTape == true) {
            
            if (self.event.sets[indexPath.section].song[indexPath.row].artistName == nil && self.event.sets[indexPath.section].song[indexPath.row].info == nil) {
                let cell = tableView.dequeueReusableCellWithIdentifier("setlistCellTapeWithoutInfo")! as! SetlistCellTapeWithoutInfo
                cell.title.text = self.event.sets[indexPath.section].song[indexPath.row].name as String
                
                print(self.event.sets[indexPath.section].song[indexPath.row].name)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("setlistCellTape")! as! SetlistCellTape
                cell.title.text = self.event.sets[indexPath.section].song[indexPath.row].name as String
                
                if (self.event.sets[indexPath.section].song[indexPath.row].artistName != nil) {
                    cell.info.text = self.event.sets[indexPath.section].song[indexPath.row].artistName as String
                } else if (self.event.sets[indexPath.section].song[indexPath.row].info != "") {
                    cell.info.text = self.event.sets[indexPath.section].song[indexPath.row].info
                }
                return cell
            }
            
        }  else if (self.event.sets[indexPath.section].song[indexPath.row].isCover == true) {
            let cell:SetlistCellWithInfo = tableView.dequeueReusableCellWithIdentifier("setlistCellWithInfo")! as! SetlistCellWithInfo
            cell.title.text = self.event.sets[indexPath.section].song[indexPath.row].name as String
            
            print(self.event.sets[indexPath.section].song[indexPath.row].artistName)
            cell.info.text = self.event.sets[indexPath.section].song[indexPath.row].artistName + " Cover"
            
            return cell
        } else if (self.event.sets[indexPath.section].song[indexPath.row].info == nil) {
            let cell:SetlistCell = tableView.dequeueReusableCellWithIdentifier("setlistCell")! as! SetlistCell
            cell.title.text = self.event.sets[indexPath.section].song[indexPath.row].name as String
            
            return cell
        } else {
            let cell:SetlistCellWithInfo = tableView.dequeueReusableCellWithIdentifier("setlistCellWithInfo")! as! SetlistCellWithInfo
            cell.title.text = self.event.sets[indexPath.section].song[indexPath.row].name as String
            cell.info.text = self.event.sets[indexPath.section].song[indexPath.row].info as String
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("headerSection") as! SetlistHeaderSectionTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.title.textColor = UIColor().buttonColor()
        
        // S'il y a plusieurs Encore, on affichera "Encore 1", "encore 2", ...
        if (self.event.sets[section].isEncore && ((section+1) != self.event.sets.count)) {
            cell.title.text = "Encore " + self.event.sets[section].name
        } else if (self.event.sets[section].isEncore ) { // S'il y en a qu'un on affichera uniquement "Encore"
            cell.title.text = "Encore"
        } else { // Sinon le nom du Set récupéré de setlist.fm
            cell.title.text = self.event.sets[section].name
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.event.sets[section].name == "") {
            return 15
        } else {
            return 65
        }
    }
    
    // Effect cell
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0
        
        UIView.animateWithDuration(0.75) {
            cell.alpha = 1.0
        }
    }
    
    func closeWindows() {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
}

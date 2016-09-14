//
//  SearchArtistViewController.swift
//  setlist
//
//  Created by Benoit Deguine on 23/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit
import Alamofire

class SearchArtistViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    var artistsSearch = [Artist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor().mainColor()
        self.view.backgroundColor = UIColor().backgroundColor()
        
        self.navigationController?.navigationBar.setBottomBorderColor(UIColor().mainColor(), height: 1)
       
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColor().mainColor().CGColor
        
        searchBar.translucent = false
        searchBar.backgroundColor = UIColor().mainColor()
        searchBar.barTintColor = UIColor().mainColor()
        searchBar.userInteractionEnabled = true
        
        self.closeButton.tintColor = UIColor().buttonColor()
        
        self.setFocusOnBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addArtist")  {
            let addArtistSegue:AddArtistViewController = segue.destinationViewController as! AddArtistViewController
            addArtistSegue.myArtist = sender as! Artist
        }
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
        
        var url:String = App.URL.musicbrainz + "artist/?query=artist:" +  (searchBar.text?.trim())! as String + "*&fmt=json"
        print(url)
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
        self.performSegueWithIdentifier("addArtist", sender: self.artistsSearch[indexPath.row])
    }
    
}

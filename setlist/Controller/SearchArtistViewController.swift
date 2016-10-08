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
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
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
        self.searchBar.layer.borderColor = UIColor().mainColor().cgColor
        
        searchBar.isTranslucent = false
        searchBar.backgroundColor = UIColor().mainColor()
        searchBar.barTintColor = UIColor().mainColor()
        searchBar.isUserInteractionEnabled = true
        
        self.closeButton.tintColor = UIColor().buttonColor()
        
        self.setFocusOnBar()
        
        self.tableView.isHidden = true
        self.labelInfo.isHidden = false
        self.labelInfo.textColor = UIColor().darkGrey()
        self.labelInfo.text = ""
        self.activityLoader.isHidden = true
        
        self.searchBar.placeholder = String(format: NSLocalizedString("add_artist_placeholder", comment: "Rechercher un artiste"))
        self.navigationItem.title = String(format: NSLocalizedString("add_artist_placeholder", comment: "Rechercher un artiste"))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        GoogleAnalytics().sendScreenView(name: "Rechercher un artiste")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addArtist")  {
            let addArtistSegue:AddArtistViewController = segue.destination as! AddArtistViewController
            addArtistSegue.myArtist = sender as! Artist
        }
    }
    
    @IBAction func closeViewController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
    
    func setFocusOnBar() {
        self.searchBar.becomeFirstResponder()
    }

    // MARK: - UISearch
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        self.tableView.isHidden = true
        self.labelInfo.text = String(format: NSLocalizedString("add_artist_search_pending", comment: "Message a afficher lors d'une recherche"))
        self.activityLoader.isHidden = false

        var url:String = App.URL.musicbrainz + "artist/?query=artist:" + (searchBar.text?.trim())! as String + "*&fmt=json"
        print(url)
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        Alamofire.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                let response = response.result.value as! NSDictionary
                let res = response.object(forKey: "artists")! as! NSArray
                let nombre:Int = response.object(forKey: "count") as! Int
                
                self.artistsSearch.removeAll()
                
                for i in res {
                    self.artistsSearch.append(Artist(value: i as! NSDictionary))
                }
                
                if (self.artistsSearch.count > 0) {
                    self.tableView.isHidden = false
                } else {
                    self.tableView.isHidden = true
                    self.labelInfo.text = String(format: NSLocalizedString("add_artist_zero_result", comment: "Aucun artiste"))
                    self.activityLoader.isHidden = true
                }
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Mark: - Tableview Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artistsSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.artistsSearch[(indexPath as NSIndexPath).row].disambiguation == nil) {
            let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            cell.textLabel?.text = self.artistsSearch[(indexPath as NSIndexPath).row].name
            return cell
        } else {
            let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cellWithDisambiguation")! as UITableViewCell
            cell.textLabel?.text = self.artistsSearch[(indexPath as NSIndexPath).row].name
            cell.detailTextLabel!.text = self.artistsSearch[(indexPath as NSIndexPath).row].disambiguation
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "addArtist", sender: self.artistsSearch[(indexPath as NSIndexPath).row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

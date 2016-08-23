//
//  SearchArtistViewController.swift
//  setlist
//
//  Created by Benoit Deguine on 23/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit
import Alamofire

class SearchArtistViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor().mainColor()
        self.view.backgroundColor = UIColor().backgroundColor()
        
        self.navigationController?.navigationBar.setBottomBorderColor(UIColor().mainColor(), height: 1)
        
        searchBar.translucent = false
        //searchBar.barTintColor = UIColor().mainColor()
        searchBar.backgroundColor = UIColor().mainColor()
        searchBar.barTintColor = UIColor().mainColor()
        // Do any additional setup after loading the view.
        
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
        print(searchBar.text! as String)
    
        var url:String = "https://api.spotify.com/v1/search?q=" +  searchBar.text! as String + "&type=artist&limit=50"
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        print(url)
        Alamofire.request(.GET, url)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("Validation Successful")
                case .Failure(let error):
                    print(error)
                }// original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
        }
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

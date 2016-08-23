//
//  ViewController.swift
//  setlist
//
//  Created by Benoit Deguine on 23/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var addNewArtist: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor().mainColor()
        self.view.backgroundColor = UIColor().backgroundColor()
        self.addNewArtist.tintColor = UIColor().buttonColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


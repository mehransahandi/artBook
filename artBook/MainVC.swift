//
//  ViewController.swift
//  artBook
//
//  Created by Mehran Sahandi on 19.10.2017.
//  Copyright © 2017 Mehran Sahandi. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func BTNAddPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "ToInfoVC", sender: nil)
        
    }
    

}


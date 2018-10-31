//
//  FirstViewController.swift
//  Remembral
//
//  Created by Aayush Malhotra on 9/21/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//
// ******For Home Page


import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var table: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

}


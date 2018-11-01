//
//  FirstViewController.swift
//  Remembral
//
//  Created by Aayush Malhotra on 9/21/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//
// ******For Home Page


import UIKit

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var patientName:String = "John Doe"
    var patientAddress:String = "123456789123 Street, Burnaby BC"
    var patientPhoneNumber:String = "123 456 7890"
    var caretakerName:String = "Jane Doe"
    var caretakerPhoneNumber:String = "987 654 3210"
    lazy var items = ["My Name:", patientName, "My Address:", patientAddress, "My Phone Number:", patientPhoneNumber, "My Caretaker:", caretakerName, "My Caretaker's Phone Number:", caretakerPhoneNumber]
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.myLabel.text = items[indexPath.item]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let EditPersonalInfoViewController = segue.destination as? EditPersonalInfoViewController {
            EditPersonalInfoViewController.intitialPatientName = patientName
            EditPersonalInfoViewController.intitialPatientAddress = patientAddress
            EditPersonalInfoViewController.intitialPatientPhoneNumber = patientPhoneNumber
            EditPersonalInfoViewController.intitialCaretakerName = caretakerName
            EditPersonalInfoViewController.intitialCaretakerPhoneNumber = caretakerPhoneNumber
        }
    }
}


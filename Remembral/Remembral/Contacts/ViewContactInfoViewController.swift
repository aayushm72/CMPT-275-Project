//
//  ViewContactInfoViewController.swift
//  Remembral
//
//  Created by Alwin Leong on 11/30/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

import UIKit

class ViewContactInfoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var relationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var contactDisplayed: ContactPerson?
    let defaultImage = UIImage(named: "contact")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let contactData = contactDisplayed {
            if (contactData.picture != nil){
                imageView.image = contactData.picture as UIImage
                imageView.contentMode = UIView.ContentMode.scaleAspectFit;
            }
            else {
                imageView.image = defaultImage
                imageView.contentMode = UIView.ContentMode.center
            }
            nameLabel.text = contactData.fullName
            relationLabel.text = contactData.relation
            phoneLabel.text = contactData.phoneNum
            addressLabel.text = contactData.address
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func SegueToContactInfo(_ segue: UIStoryboardSegue) {
        
    }

}

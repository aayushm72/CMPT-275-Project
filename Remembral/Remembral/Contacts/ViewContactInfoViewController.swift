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
            let callGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callWith))
            callGestureRecognizer.numberOfTouchesRequired = 1
            phoneLabel.addGestureRecognizer(callGestureRecognizer)
            phoneLabel.isUserInteractionEnabled = true
        }
    }
    
    @objc
    func callWith(gestureRecognizer: UIGestureRecognizer){
        if let contactData = contactDisplayed, let url = URL(string: "tel://\(contactData.phoneNum!)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
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

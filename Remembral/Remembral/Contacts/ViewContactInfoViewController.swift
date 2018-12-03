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
        let deleteBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 25))
        deleteBtn.setTitle("Delete", for: .normal)
        deleteBtn.setTitleColor(.red, for: .normal)
        deleteBtn.backgroundColor = UIColor(displayP3Red: 0.88, green: 0.67, blue: 0.34, alpha: 1.0)
        deleteBtn.layer.cornerRadius = 4.0
        deleteBtn.layer.masksToBounds = true
        deleteBtn.addTarget(self, action: #selector(deleteContact), for: .touchUpInside)
        let rightDeleteButton = UIBarButtonItem(customView: deleteBtn)
            //UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteContact))
        //rightDeleteButton.tintColor = .red
        self.navigationItem.setRightBarButtonItems([rightDeleteButton], animated: true)
        
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
    
    //Call the selected phonenumber
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
    
    //Delete the current contact
    @objc 
    func deleteContact(){
        if let contactToRemove = contactDisplayed {
            let name = contactToRemove.fullName!
            let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete (\(name)) from your contacts list?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
                self.navigationController?.navigationBar.isUserInteractionEnabled = false
                ContactPerson.deleteContact(contactToDelete: contactToRemove, completion: {
                    (result) in
                    if result {
                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
                        self.performSegue(withIdentifier:"UnwindToContactsFromInfo", sender: self)
                    }
                })
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
            self.present(alert, animated: true, completion: nil)
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

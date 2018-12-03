//
//  RegisterViewController.swift
//  Remembral
//
//Team: Group 2
//  Created by Aayush Malhotra on 11/27/18.
//  Edited: Alwin Leong, Aayush Malhotra
//
//  Register for Application view controller.
//  Will be used in Version 3
//  Known bugs:
//
//

import UIKit
import Firebase
import SwiftKeychainWrapper

// Structure for Register View.
class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var email:String!
    var password:String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var imageURL = ""
    
    let dataValues = ["Patient", "Caretaker"]
    
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var UserPhoneNo: UITextField!
    @IBOutlet weak var UserAddress: UITextField!
    @IBOutlet weak var UserTypePicker: UIPickerView!
    @IBOutlet weak var userImagePicker: UIImageView!
    
    // Did screen load, set up UI, Set up Image Picking option for Profile.
    override func viewDidLoad() {
        super.viewDidLoad()
        UserTypePicker.delegate = self
        self.RegisterButton.layer.cornerRadius = 5; // this value vary as per your desire
        self.RegisterButton.clipsToBounds = true;
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // Setup Image upload, ask user to select an image for profile picture.
    // Deal with errors and display error cause.
    func uploadImg(completionHandler: ((String, Bool) -> Void)?) {
        guard let img = userImagePicker.image, imageSelected == true else {
            print("image needs to be selected")
            completionHandler?("", true)
            return
        }
        
        guard let imgData = img.jpegData(compressionQuality: 0.5) else {
            completionHandler?("", false)
            return
        }
        let imgUid = NSUUID().uuidString
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let storageref = Storage.storage().reference().child(imgUid)
        storageref.putData(imgData, metadata: metadata) {
              (result, error) in
                if error != nil {
                    print("Error uploading!")
                    completionHandler?("", false)
                    return
                }
                storageref.downloadURL {
                    (url, error) in
                    guard let downloadURL = url?.absoluteString else {
                        print("Failed to get download URL.")
                        completionHandler?("", false)
                        return
                    }
                    completionHandler?(downloadURL, true)
                }
            }
    }
    
    // Image picker view for profile image.
    @IBAction func selectedImgPicker (_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Deal with errors on image picker view.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            userImagePicker.image = image
            imageSelected = true
        } else {
            print("image wasn't selected")
        }
        imagePicker.dismiss(animated: true)
    }
    
    // Number of columns for picker view for choosing patient or caretaker designation.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Values for picker view for choosing patient or caretaker designation.
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = dataValues[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    // Number of rows for picker view for choosing patient or caretaker designation.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataValues.count
    }
    
    // Back button to cancel registering process.
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // On Register:
    // 1) Check if user has filled any information in.
    // 2) Create User with all the information entered by creating a new user on the database.
    // 3) Deal with errors on registering such as no internet access or incomplete information.
    @IBAction func onRegister(_ sender: Any) {
        //error if any text field is left blank
        if (self.UserName.text?.isEmpty)! || (self.UserPhoneNo.text?.isEmpty)! || (self.UserAddress.text?.isEmpty)! {
            let errorMessage = UIAlertController(title: "Incomplete Info", message: "Fill in all the information before you register.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            errorMessage.addAction(OKAction)
            self.present(errorMessage, animated: true, completion: nil)
            return
        }
        //create user
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
            if error != nil {
                //create user error
                let errorMessage = UIAlertController(title: "Error", message: "A error ocured while trying to register. Make sure you are connected to the internet and try again.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                errorMessage.addAction(OKAction)
                self.present(errorMessage, animated: true, completion: nil)
                return
            }
            //user created
            //update keychain values
            KeychainWrapper.standard.set(self.email, forKey: "email")
            KeychainWrapper.standard.set(self.password, forKey: "password")
            //add user info to database
            var user = User()
            user.name = self.UserName.text
            user.phNo = self.UserPhoneNo.text
            user.address = self.UserAddress.text
            user.caretakerName = ""
            user.caretakerPhNo = ""
            user.type = self.dataValues[self.UserTypePicker.selectedRow(inComponent: 0)]
            self.uploadImg(completionHandler: {
                (url, success) in
                if success == false {
                    let errorMessage = UIAlertController(title: "Upload failed.", message: "Image Upload failed, please try again.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    errorMessage.addAction(OKAction)
                    self.present(errorMessage, animated: true, completion: nil)
                    return
                }
                user.imageURL = url
              
                let uid = authResult?.user.uid
                FirebaseDatabase.sharedInstance.userObj = user
                let childRef = FirebaseDatabase.sharedInstance.usersRef.child(uid!)
                let values : [String:Any] = ["name": user.name,
                                             "address": user.address,
                                             "phNo": user.phNo,
                                             "caretakerName": user.caretakerName,
                                             "caretakerPhNo": user.caretakerPhNo,
                                             "type": user.type,
                                             "imageURL": user.imageURL]
                childRef.updateChildValues(values)
                
                //segue to application
                let userType = FirebaseDatabase.sharedInstance.userObj.type
                FirebaseDatabase.sharedInstance.LoadContacts(completion: {
                    (_) in
                    if userType == "Patient" {
                        self.performSegue(withIdentifier: "toPatientAppfromRegister", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "toCaretakerAppfromRegister", sender: nil)
                    }
                })
                
            })
        })
    }
}

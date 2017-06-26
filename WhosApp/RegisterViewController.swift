//
//  RegisterViewController.swift
//  WhosApp
//
//  Created by Zhiyuan Cui on 6/24/17.
//  Copyright © 2017 Zhiyuan Cui. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import MBProgressHUD
import MobileCoreServices

class RegisterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var RegisterBtnOutlet: UIButton!
    
    
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Mark: IBActions
    @IBAction func RegisterBtnPressed(_ sender: UIButton) {
        let email = emailTextField.text;
        let password = passwordTextField.text;
        let username = usernameTextField.text;
        
        if isValidEmail(email: email! ) && password != ""{
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinnerActivity?.mode = MBProgressHUDMode.indeterminate
            spinnerActivity?.isUserInteractionEnabled = false;
            
            register(email: email!, password: password!, username: username!, avatarImage: avatarImage);
        }
        
    }
    
    @IBAction func CameraBtnPressed(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = Camera(delegate_: self)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style:.default) {
            (alert: UIAlertAction!) in
            camera.PresentPhotoCamera(target: self, canEdit: true)
        }
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style:.default) {
            (alert: UIAlertAction!) in
            
            camera.PresentPhotoLibrary(target: self, canEdit: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style:.cancel) {
            (alert: UIAlertAction!) in
            
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func isValidEmail(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func register(email: String, password:String, username: String, avatarImage: UIImage?) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            if error != nil {
                
                let alert = UIAlertController(title:"Fail to Register",message:"Fail to register", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"Try Again", style:UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion:nil)
                
            } else {
                
                //Success, Then try to upload Avatar Image
                if avatarImage == nil {
                    
                } else {
                    //upload avatar image
                    let storageRef = FIRStorage.storage().reference().child((user?.uid)!+"avatar.png")
                    if let uploadData = UIImagePNGRepresentation( avatarImage! ) {
                        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                print( error! )
                                return
                            } else {
                                if let avatarUrl = metadata?.downloadURL()?.absoluteString{
                                    let values = ["name": username, "email": email,"avatarImageUrl":avatarUrl]
                                    self.registerUserInDB(withuid: (user?.uid)!, values: values as [String : AnyObject])
                                }
                            }
                        })
                    }
                    
                }
                
                
                self.loginUser(email: email, password: password)
            }
        })

    }
    
    private func registerUserInDB(withuid:String,values:[String: AnyObject]){
        
        let ref = FIRDatabase.database().reference(fromURL: FIRDatabaseRef)
        let usersReference = ref.child("users").child(withuid)
        usersReference.updateChildValues(values) { (error, ref) in
            if error != nil {
                print( error! )
                return
            }
        }
    }
    
    func loginUser(email: String, password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
            if error == nil{
                
                //Go to Application
                let vc = UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "RecentVC") as! UITabBarController
                vc.selectedIndex = 0;
                self.present(vc, animated: true, completion: nil)
                
            }
        })
    }

    //Mark: UIImagePickerController delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.avatarImage = (info[UIImagePickerControllerEditedImage] as! UIImage)
        
        picker.dismiss(animated: true, completion: nil)
    }
}

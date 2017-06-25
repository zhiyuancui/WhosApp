//
//  WelcomeViewController.swift
//  WhosApp
//
//  Created by Zhiyuan Cui on 6/24/17.
//  Copyright © 2017 Zhiyuan Cui. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase
import SwiftKeychainWrapper

class WelcomeViewController: UIViewController {

    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    var loginTryTimes = 0;
    
    
    //Check User is logged in.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true;
                
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser != nil {
            
            DispatchQueue.main.sync {
                let vc = UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "RecentVC") as! UITabBarController
                vc.selectedIndex = 0;
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginBtnPressed(_ sender: Any) {
     
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinnerActivity?.mode = MBProgressHUDMode.indeterminate
            spinnerActivity?.labelText = "Loging..."
            spinnerActivity?.detailsLabelText = "Please Wait"
            spinnerActivity?.isUserInteractionEnabled = false;
            
            loginUser(email: emailTextField.text!, password: passwordTextField.text!);
            
        } else {
            let alert = UIAlertController(title: "Incorrect Password", message: "The password you entered is incorrect. Please try again", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        
    }
    
    func loginUser(email: String, password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
            if error == nil{
                
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
                self.view.endEditing(false)
                
                //Save Keychain
                if let user = user{
                    self.completeSignIn(id: user.uid)
                }
                
                //Go to Application
                let vc = UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "RecentVC") as! UITabBarController
                vc.selectedIndex = 0;
                self.present(vc, animated: true, completion: nil)
                
                
            }else{
                //password not match
                if self.loginTryTimes == 0{
                    let alert = UIAlertController(title:"Incorrect Password",message:"Your password is not correct.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title:"Try Again", style:UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated:true, completion:nil)
                }else {
                    let alert = UIAlertController(title:"Forgotten Password?",message:"Your password is not correct.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title:"Try Again", style:UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated:true, completion:nil)
                }
                self.loginTryTimes+=1;
            }
            
        })
        
        
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion:{
            (user, error) in
            if error != nil{
                print("MyPhotoApp: Unable to authenticate with Firebase. \(error)")
            }else{
                print("MyPhotoApp: successfully authenticated with Firebase")
                if let user = user{
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    //Save user credential using IOS Keychain
    func completeSignIn(id: String){
        //KeychainWrapper.standard.set(id,forKey: KEY_UID);
        //performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }
}

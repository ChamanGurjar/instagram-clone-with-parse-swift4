//
//  ViewController.swift
//  Instagram Clone Swift4
//
//  Created by Chaman Gurjar on 06/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import Parse

//Parse server is hosted on -> https://back4app.com
class ViewController: UIViewController {
    
    @IBOutlet weak var emailIdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private var doingSignUp = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    @IBAction func signUpOrLoginActivity(_ sender: UIButton) {
        if emailIdTF.text == "" || passwordTF.text == "" {
            showAlert(title: "Error", message: "Please enter you details")
        } else if (doingSignUp) {
            signUpUser()
        } else {
            loginUser()
        }
        
    }
    
    private func signUpUser() {
        let user = PFUser()
        user.username = emailIdTF.text!
        user.password = passwordTF.text!
        user.email = emailIdTF.text!
        
        user.signUpInBackground { (success, err) in
            if let error = err {
                self.showAlert(title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
            } else {
                print("\(self.emailIdTF.text!) signedUpSuccessfully")
            }
        }
    }
    
    private func loginUser() {
        PFUser.logInWithUsername(inBackground: emailIdTF.text!, password: passwordTF.text!) { (user, err) in
            if let error = err {
                print(error.localizedDescription)
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                print(user ?? "No User Found")
            }
        }
    }
    
    
    @IBAction func SwitchLoginSignUpMode(_ sender: UIButton) {
        
        if doingSignUp {
            doingSignUp = false
            signUpButton.setTitle("Login", for: [])
            loginButton.setTitle("SignUp", for: [])
        } else {
            doingSignUp = true
            signUpButton.setTitle("SignUp", for: [])
            loginButton.setTitle("Login", for: [])
        }
    }
    
    
    private func showAlert(title: String,  message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


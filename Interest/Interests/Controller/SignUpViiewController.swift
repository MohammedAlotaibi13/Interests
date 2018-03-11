//
//  SignUpViiewController.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 4/8/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit
import Firebase
// MARK: - SignUpViewController
class SignUpViiewController : UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var signInButton: UIButton!
    // MARK: Outllets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let internet = Reachability()!
    
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // checking internet
        
        internet.whenUnreachable = { _ in
            DispatchQueue.main.async {
                AlertViewController.alert("Error", "No Internet Connection", in: self)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkingInternet), name: .reachabilityChanged, object: internet)
        do{
            try internet.startNotifier()
        } catch {
            print("error")
        }
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passWordTextField.delegate = self
    }
    
    // MARK: Functions
    
    
    @objc func checkingInternet(_ notification: Notification){
        let reachInternet = notification.object as! Reachability
        if reachInternet.isReachable {
            print("Internet is on")
        } else {
            DispatchQueue.main.async {
                AlertViewController.alert("Error", "No Internet Connection", in: self)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        //self.signUpUi(tru)
        self.processSignUp()
        // self.signUpUi(false)
    }
    
    func processSignUp(){
        // valdite inputs information
        
        self.signUpUi(false)
        activityIndicator.startAnimating()
        
        guard let name = nameTextField.text ,let email = emailTextField.text , let passWord = passWordTextField.text  else
        {
            print("No name found")
            return
        }
        if name == "" || email == "" || passWord == "" {
            AlertViewController.alert("Error", "Please Fill All Field", in: self)
        }
        // sign up by firebase
        Auth.auth().createUser(withEmail: email, password: passWord) { (user, error) in
            if error != nil{
                print(error?.localizedDescription)
                AlertViewController.alert(nil, error?.localizedDescription as! String, in: self)
                self.activityIndicator.stopAnimating()
                self.signInButton.isEnabled = true
                return
            } else {
                
                print("sign in successfuly")
                self.completSignIn()
                self.activityIndicator.stopAnimating()
                self.signUpUi(true)
            }
            
        }
    }
    
    func completSignIn(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func signUpUi(_ enabled: Bool){
        
        // transpare button if the user press it
        signInButton.isEnabled = enabled
        
        if enabled {
            signInButton.alpha = 1.0
            self.signInButton.isEnabled = true
        } else {
            signInButton.alpha = 0.5
            self.signInButton.isEnabled = false
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extension SignUpViewController
extension SignUpViiewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.returnKeyType == UIReturnKeyType.go){
            self.processSignUp()
        }
        return true
    }
    
}

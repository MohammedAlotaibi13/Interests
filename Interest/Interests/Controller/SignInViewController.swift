//
//  SignInViewController.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 4/7/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

// MARK:- UIViewController
class SignInViewController: UIViewController, UITextFieldDelegate ,GIDSignInUIDelegate {
    
    // MARK: Outlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var googleSigninButton: GIDSignInButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var activityIndicater: UIActivityIndicatorView!
    
    // MARK : Properties
    let internet = Reachability()!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checking Internet Connection
        internet.whenUnreachable = { _ in
            AlertViewController.alert("Error", "No Internet Connection", in: self)
            self.activityIndicater.stopAnimating()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkingInternet), name: .reachabilityChanged, object: internet)
        do{
            try internet.startNotifier()
        } catch {
            print("error")
        }
        
        // delegate for google sign in
        GIDSignIn.sharedInstance().uiDelegate = self
        
        emailTextField.delegate = self
        passWordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: Function
    
    @objc func checkingInternet(_ notification: Notification){
        let reachInternet = notification.object as! Reachability
        if reachInternet.isReachable {
            print("Internet is on")
        } else {
            DispatchQueue.main.async {
                AlertViewController.alert("Error", "No Internet Connection", in: self)
                self.activityIndicater.stopAnimating()
            }
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func logInButton(_ sender: Any) {
        self.logInUi(false)
        self.processLogIn()
        self.logInUi(true)
    }
    
    func processLogIn(){
        activityIndicater.startAnimating()
        guard let email = emailTextField.text , let passWord = passWordTextField.text else {
            return
        }
        // sign in user firebase authentication
        
        if email == "" || passWord == "" {
            AlertViewController.alert("Error", "Please Fill The Email Field", in: self)
            self.activityIndicater.stopAnimating()
            self.logInUi(false)
            return
        }
        Auth.auth().signIn(withEmail: email, password: passWord) { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                AlertViewController.alert(nil, error?.localizedDescription as! String, in: self)
                self.activityIndicater.stopAnimating()
                self.logInButton.isEnabled = true
                return
            } else {
                print("sign in successfuly")
                self.completeLogIn()
                self.activityIndicater.stopAnimating()
            }
        }
    }
    
    func completeLogIn(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func logInUi(_ enabled: Bool){
        // transpare button if the user press it
        logInButton.isEnabled = enabled
        
        if enabled {
            logInButton.alpha = 1.0
            self.logInButton.isEnabled = true
        } else {
            logInButton.alpha = 0.5
            self.logInButton.isEnabled = false
        }
    }
    
}
// MARK: Extension SignInViewController
extension SignInViewController {
    
    // implement go keyboard button
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //  textField.resignFirstResponder()
        if (textField.returnKeyType == UIReturnKeyType.go){
            self.processLogIn()
        }
        return true
    }
}

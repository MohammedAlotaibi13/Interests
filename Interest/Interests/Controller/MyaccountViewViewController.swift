//
//  MyaccountViewViewController.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 4/24/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit
import Firebase

class MyaccountViewViewController: UIViewController {
    
    @IBOutlet weak var myAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.myAccountButton.setTitle("Sign Out", for: .normal)
                return
            } else {
                self.myAccountButton.setTitle("Sign In", for: .normal)
                return
            }
        }
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        if self.myAccountButton.currentTitle == "Sign Out" {
            self.singOut()
            self.myAccountButton.setTitle("Sign In", for: .normal)
        } else {
            self.signIn()
            self.myAccountButton.setTitle("Sign Out", for: .normal)
        }
    }
    
    func singOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //   AlertViewController.alert(nil, "Sign Out Successfuly", in: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            AlertViewController.alert(nil, "Couldn't Sign Out Try Again ", in: self)
        }
        AlertViewController.alert(nil, "Sign Out Successfuly", in: self)
    }
    
    func signIn(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.present(controller, animated: true, completion: nil)
    }
    
}

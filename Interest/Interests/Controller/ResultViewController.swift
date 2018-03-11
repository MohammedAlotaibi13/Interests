//
//  ResultViewController.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 3/2/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit
import Firebase
import CoreData


// MARK: - ResultViewController

class ResultViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {
    
    // MARK: Outlets
    
    @IBOutlet weak var mytableView: UITableView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var activiteyIndicator: UIActivityIndicatorView!
    
    
    // MARK: Properties
    var refrence : DatabaseReference!
    var resultModel = [ResultModel]()
    var income = Double()
    var typeoFLoan = Int()
    var nationality = Int()
    var selectedTag = [Int]()
    let bankImages = ["alahli-bank","Alinma-Bank", "BANK-ALBILAD" , "Al-Rajhi-Bank","Investment-bank","Riyad-bank"]
    var save = [String]()
    let internet = Reachability()!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mytableView.delegate = self
        mytableView.dataSource = self
        
        // checking internet connection
        internet.whenReachable = { _ in
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if user != nil {
                    DispatchQueue.main.async {
                        self.uploadFromFirebase()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.signInPage()
                    }
                    print("failed to log in")
                    return
                }
                
            }
        }
        
        internet.whenUnreachable = { _ in
            
            DispatchQueue.main.async {
                AlertViewController.alert("Error", "No Internet Connection.", in: self )
                self.activityIndicatorOff()
            }
        }
        // method to check internet while useing controller
        NotificationCenter.default.addObserver(self, selector: #selector(checkingInternet), name: .reachabilityChanged, object: internet)
        do{
            try internet.startNotifier()
        } catch {
            print("error")
        }
    }
    
    
    @objc func checkingInternet(_ notification: Notification){
        let reachInternet = notification.object as! Reachability
        if reachInternet.isReachable {
            print("Internet is on")
        } else {
            DispatchQueue.main.async {
                AlertViewController.alert("Error", "No Internet Connection", in: self)
                self.activityIndicatorOff()
            }
            
        }
    }
    
    // MARK: functions
    
    func uploadFromFirebase(){
        
        //firebase
        // start activityIndicator
        self.acticityIndicatorOn()
        
        refrence = Database.database().reference()
        refrence.observe(DataEventType.value) { (snapShot) in
            if snapShot.childrenCount > 0 {
                // remove all data in array
                self.resultModel.removeAll()
                
                for results in snapShot.children.allObjects as! [DataSnapshot] {
                    let resultData = results.value as! [String : AnyObject]
                    let result = ResultModel()
                    
                    let name = resultData[Constants.firebase.name]
                    result.bankName = name as! String
                    // self.bankName.append(result)
                    let rate = resultData[Constants.firebase.interestRate]
                    result.intrestRate = rate as! Double
                    let years = resultData[Constants.firebase.duration]
                    result.duration = years as! Double
                    
                    // check the nationality of the user from pickerView to upload decent data
                    
                    if self.nationality == 1 {
                        let loan = resultData[Constants.firebase.totalLoan]
                        result.totalLoan = loan as! Double
                    } else {
                        let loan = resultData[Constants.firebase.toatalLoanNonSaaudi]
                        result.totalLoan = loan as! Double
                    }
                    let instal = resultData[Constants.firebase.instalment]
                    result.instalment = instal as! Double
                    
                    self.resultModel.append(result)
                    print(result.bankName)
                }
                
                DispatchQueue.main.async {
                    self.activityIndicatorOff()
                    self.activiteyIndicator.stopAnimating()
                    self.mytableView.reloadData()
                }
                
            } else {
                print("No data in DataBase")
                AlertViewController.alert("Error", "No Data Found Try Again ", in: self)
            }
        }
        
    }
    
    func signInPage(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.present(controller, animated: true, completion: nil)
    }
    func acticityIndicatorOn(){
        self.secondView.isHidden = false
        self.activiteyIndicator.startAnimating()
    }
    
    func activityIndicatorOff(){
        self.secondView.isHidden = true
        self.activiteyIndicator.stopAnimating()
    }
    
    @IBAction func doneButtom(_ sender: Any) {
        // back to calculateViewController
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- Extensions ResultViewController
extension ResultViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableView.dequeueReusableCell(withIdentifier: "Cell") as! ResultTableViewCell
        let result = self.resultModel[indexPath.row]
        
        // make some math before show it in screen
        // 1- we should multiply the monthly income by total loan from fireBase to get the total loan
        let totalLoan = self.income * result.totalLoan
        /* 2- we should multiply the montly icomne and divided by 100 to get how much customer must pay to bank as instalment depond on law of goverment dhould be third of montly income */
        let instal = self.income * result.instalment / 100
        /* 3- to get interest amount customer should pay to bank we have to multiply totalloan by interest rate from firebase  and divided by 100 the result also shoul be multiply by duration of loan to get final result*/
        let interestAmount = (totalLoan * result.intrestRate / 100) * (result.duration)
        cell.bankName.text = result.bankName
        cell.totalLoan.text = String(totalLoan)
        cell.duration.text = String(result.duration)
        cell.inatalment.text = String(instal)
        cell.interestRate.text = String(result.intrestRate)
        cell.amount.text = String(interestAmount)
        cell.imageBank.image = UIImage(named: self.bankImages[indexPath.row])
        // implementing save button
        cell.save.tag = indexPath.row
        if selectedTag.contains(indexPath.row)  {
            print(indexPath.row)
            cell.save.setTitle("Saved", for: .normal)
            // cell.like.isEnabled = false
            cell.isUserInteractionEnabled = false
        } else {
            cell.save.addTarget(self, action: #selector(saveButton(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func saveButton(_ sender: AnyObject) {
        let favorite = LikeResult(context: CoreDataStack.shared.context)
        let result = self.resultModel[sender.tag]
        
        // add the cell tag to avoid save it again
        selectedTag.append(sender.tag)
        self.mytableView.reloadData()
        
        let total = self.income * result.totalLoan
        let instal = self.income * result.instalment / 100
        let amount = (total * result.intrestRate / 100) * (result.duration)
        if let imageBank = UIImage(named: self.bankImages[sender.tag]) {
            let data = UIImagePNGRepresentation(imageBank) as NSData?
            favorite.bankImage = data! as Data
            print("favorite bank image : \(favorite.bankName) imageBank :\(result.bankName)")
        }
        
        favorite.bankName = result.bankName
        favorite.totalLoan = total
        favorite.duration = result.duration
        favorite.instalment = instal
        favorite.interestRate = result.intrestRate
        favorite.amount = amount
        
        CoreDataStack.shared.save()
        print("BankName : \(favorite.bankName) total Loan : \(favorite.totalLoan) duration : \(favorite.duration) instalemt : \(favorite.instalment) interestRate : \(favorite.interestRate) amount : \(favorite.amount) image : \(favorite.bankImage?.count) ")
        
    }
    
}

//
//  ICalculateViewController.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 2/28/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//


import UIKit
// MARK: -  CalculateViewController
class CalculateViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource, UITextFieldDelegate {
    
    
    // MARK: Outlets
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var statuesPicker: UIPickerView!
    @IBOutlet weak var typeOfLoanPicker: UIPickerView!
    @IBOutlet weak var montlyIncomeTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:  Properties
    var loans = ["Personal loan"]
    var statues = ["Saudi" , "Non Saudi"]
    var placementAnswerLoan = 0
    var placementAnswerStatues = 0
    
    // MARK: life Cycle
    override func viewDidLoad(){
        
        super.viewDidLoad()
        // add done button to keyboard
        let kd = UIToolbar()
        kd.sizeToFit()
        let donebutton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClick))
        kd.items = [donebutton]
        montlyIncomeTextField.inputAccessoryView = kd
    }
    // MARK: Picker Functions
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        var countRow : Int = loans.count
        if pickerView.tag == 2 {
            countRow = self.statues.count
        }
        return countRow
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            let  titleRow = self.loans[row]
            return titleRow
        } else if pickerView.tag == 2 {
            let titleRow = self.statues[row]
            return titleRow
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // we want to know which user select from picker based on number of row .
        if pickerView.tag == 1 {
            placementAnswerLoan = row
            print(placementAnswerLoan)
        } else {
            placementAnswerStatues = row
            print(placementAnswerStatues)
        }
    }

    //MARK: functions
    
    @IBAction func calculateButton(_ sender: Any) {
        // make sure incomeTextField != nil
        
        if montlyIncomeTextField.text != "" {
            self.activityIndicator.startAnimating()
            performSegue(withIdentifier: "segue", sender: self)
            self.activityIndicator.stopAnimating()
        } else {
            print("No income added ")
            AlertViewController.alert(nil, "Please Add Your Income", in: self)
        }
    }
    // push the data from this controller to ResultViewController by using the method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as! ResultViewController
        resultViewController.income = Double(montlyIncomeTextField.text!)!
        resultViewController.nationality = placementAnswerStatues
        resultViewController.typeoFLoan = placementAnswerLoan
    }
}

extension CalculateViewController {
    
    @objc func doneClick(){
        self.view.endEditing(true)
    }
}

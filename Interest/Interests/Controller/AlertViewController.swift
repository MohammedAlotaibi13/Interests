//
//  AlertViewController.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 4/25/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit

public class AlertViewController {
    
    class  func alert(_ title: String?,_ message: String?, in vs: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            vs.present(alert, animated: true, completion: nil)
        }
    }
}

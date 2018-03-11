//
//  InternetChecking.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 4/26/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit

public class InternetChecking {
    
      let reachability = Reachability()

    class func InternetIsOff(_ completionhandler: @escaping (_ success: Bool ,_ error: String?)->Void) {
        let reachability = Reachability()
   
        if reachability!.whenReachable = { reachability in
            completionhandler(true, nil)
        }
        
   
    }
    
    
    
}

//
//  InternetConnection.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 4/26/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit

public class InternetConnection {
    
    class func InternetOn(){
    
        let reachability = Reachability()
        reachability?.whenReachable = { _ in
            completionhandler(true, nil)
        }
        reachability?.whenUnreachable = { _ in
            completionhandler(false, "No Internet Connection ***")
        }
    }
    
}

//
//  FavoritTableViewCell.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 4/18/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit

class FavoritTableViewCell: UITableViewCell {
    
    
    // MARK:  Outliets  
    
    @IBOutlet weak var bankImage: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    
    @IBOutlet weak var totalLoan: UILabel!
    @IBOutlet weak var interesteRate: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var instalment: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

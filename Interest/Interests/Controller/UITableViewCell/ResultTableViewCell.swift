//
//  ResultTableViewCell.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 4/12/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageBank: UIImageView!
    
    @IBOutlet weak var bankName: UILabel!
    
    @IBOutlet weak var totalLoan: UILabel!
    @IBOutlet weak var interestRate: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var inatalment: UILabel!
    
    @IBOutlet weak var save: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

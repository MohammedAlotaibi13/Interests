//
//  ArticleTableViewCell.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 3/14/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

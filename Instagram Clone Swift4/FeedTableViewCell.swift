//
//  FeedTableViewCell.swift
//  Instagram Clone Swift4
//
//  Created by Chaman Gurjar on 10/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postedImge: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

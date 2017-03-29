//
//  ReviewFilterCell.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/9/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class ReviewFilterCell: UITableViewCell {
    
    @IBOutlet var labelType     : UILabel!
    @IBOutlet var labelStar     : UILabel!
    @IBOutlet var buttonRadio   : UIButton!
    @IBOutlet var buttonBox     : UIButton!
    
    @IBOutlet var star1         : UIImageView!
    @IBOutlet var star2         : UIImageView!
    @IBOutlet var star3         : UIImageView!
    @IBOutlet var star4         : UIImageView!
    @IBOutlet var star5         : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

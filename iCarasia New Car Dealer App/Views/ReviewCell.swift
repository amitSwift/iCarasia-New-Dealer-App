//
//  ReviewCell.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var labelUser: UILabel!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelContent: UILabel!
    
    @IBOutlet var buttonReply: UIButton!
    //reply user's outlet for cell2 and cell3
    
    @IBOutlet var imageReplyUser: UIImageView!
    @IBOutlet var labelNameReplyUser: UILabel!
    @IBOutlet var labelDateReply: UILabel!
    @IBOutlet var labelContentReply: UILabel!
    
    @IBOutlet var buttonEdit: UIButton! //in cell replycell2
    
    @IBOutlet var buttonCross: UIButton!//in cell replycell2
    @IBOutlet var buttonSubmit: CustomButton!//in cell replycell2
    @IBOutlet var commentText: CustumTextView!//in cell replycell2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

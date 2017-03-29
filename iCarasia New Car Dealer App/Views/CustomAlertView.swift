//
//  CustomAlertView.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class CustomAlertView: UIView {

    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomAlertView", bundle: Bundle.main).instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
    @IBAction func crossAction(_ sender: AnyObject) {
        
        self.removeFromSuperview()
    }
    
    @IBAction func tickAction(_ sender: AnyObject) {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

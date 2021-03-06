//
//  PendingPopUp.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/21/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

protocol MJPendingPopupDelegate : NSObjectProtocol{
    
    func cancelButtonClickedPendingPopup(_ secondDetailViewController: PendingPopUp)
}

class PendingPopUp: UIViewController {
    
    public var delegate: MJPendingPopupDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func crossAction(_ sender: UIButton) {
        
        self.delegate?.cancelButtonClickedPendingPopup(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

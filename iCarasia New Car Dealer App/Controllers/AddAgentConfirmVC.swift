//
//  AddAgentConfirmVC.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/20/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

protocol MJAddConfirmPopupDelegate : NSObjectProtocol{
    
    func cancelButtonClickedAddAgentConfirm(_ secondDetailViewController: AddAgentConfirmVC)
}

class AddAgentConfirmVC: UIViewController {
    
    public var delegate: MJAddConfirmPopupDelegate?
    
    @IBOutlet weak var mLabelText      : UILabel!
    
    var mPhoneNumber    = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mLabelText.text =  "\(self.mPhoneNumber) has been added to your dealership.If you don't see your agent immediately, please ask your agent to first create your account"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        
        self.delegate?.cancelButtonClickedAddAgentConfirm(self)
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

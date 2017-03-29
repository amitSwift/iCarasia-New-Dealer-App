//
//  ChangeBranchManagerPopUpVC.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/27/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

protocol MJChangeBMPopupDelegate : NSObjectProtocol{
    
    func cancelButtonClickedSelectBranchManager(_ secondDetailViewController: ChangeBranchManagerPopUpVC)
    func tickButtonClickedSelectBranchManager(_ secondDetailViewController: ChangeBranchManagerPopUpVC)
}


class ChangeBranchManagerPopUpVC: UIViewController {
    
    weak var delegate: MJChangeBMPopupDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func crossAction(_ sender: UIButton) {
        
        self.delegate?.cancelButtonClickedSelectBranchManager(self)
    }
    @IBAction func ticAction(_ sender: UIButton) {
        
        self.delegate?.tickButtonClickedSelectBranchManager(self)
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

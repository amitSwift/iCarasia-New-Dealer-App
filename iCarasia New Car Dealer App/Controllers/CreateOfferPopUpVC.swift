//
//  CreateOfferPopUpVC.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/24/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

protocol MJCreateOfferPopupDelegate : NSObjectProtocol{
    
    func cancelButtonClickedCreateOffer(_ secondDetailViewController: CreateOfferPopUpVC)
    func tickButtonClickedCreateOffer(_ secondDetailViewController: CreateOfferPopUpVC)
}

class CreateOfferPopUpVC: UIViewController {

    weak var delegate: MJCreateOfferPopupDelegate?
    
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
        
        self.delegate?.cancelButtonClickedCreateOffer(self)
    }
    @IBAction func ticAction(_ sender: UIButton) {
        
        self.delegate?.tickButtonClickedCreateOffer(self)
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

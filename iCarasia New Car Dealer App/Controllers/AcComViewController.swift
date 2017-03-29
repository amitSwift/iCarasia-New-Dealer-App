//
//  AcComViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class AcComViewController: UIViewController {

    
    var mUserName : String!
    @IBOutlet weak var mLabelInfo   : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.//
        
        self.title      = "CREATE ACCOUNT"
        mLabelInfo.text = "Thank you \(mUserName!) for signing up with Carlist.my's new car dealer program. Our account manager will get in touch with you as soon as possible."
        
        self.navigationItem.setHidesBackButton(true, animated:true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.//
    }
    
    @IBAction func gotItAction( sneder : UIButton){
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
        //let delegate = UIApplication.shared.delegate as! AppDelegate
        //delegate.updateRootController( loginStatus: true )
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

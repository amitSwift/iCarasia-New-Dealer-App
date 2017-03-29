
//
//  ProfileViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,MJPendingPopupDelegate{
    
    
    internal func cancelButtonClickedPendingPopup(_ secondDetailViewController: PendingPopUp) {
        
        print("Cross Clicked")
        
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    
    
    
    @IBOutlet weak var mImageViewUser       : UIImageView!
    @IBOutlet weak var mLabelUserName       : UILabel!
    @IBOutlet weak var mLabelPhoneNumber    : UILabel!
    
    var mDictUserInfo = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view. //
        
        self.title                  = "Profile"
        self.navigationItem.title   = "PROFILE"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.profile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func profile (){
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        servicesManager.salesAgentProfile(parameters: nil, completion: { (result, error) in
            
            DispatchQueue.main.async {
                
                if let error =  result.value(forKey: "error") {
                    
                    print(error)
                    
                    //TSMessage.showNotification(in: self , title: "\n\(result.value(forKey: "error") as! String)", subtitle: nil, type: TSMessageNotificationType.message)
                    
                    if let value = result.value(forKey: "error") {
                        
                        if value as! String == "Unauthenticated." {
                            
                            //SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
                            let servicesManager = ServicesManager()
                            servicesManager.autheticateUser(parameters: nil, completion: { (result, error) in
                                
                                DispatchQueue.main.async {
                                    //SVProgressHUD.dismiss()
                                    if let token = result.value(forKey: "token") {
                                        // Save Token To User Defaults //
                                        let tokenValue = UserDefaults()
                                        tokenValue.set(token, forKey: "iCar_Token")
                                        self.profile()
                                    }
                                }
                            })
                        }
                        else{
                            SVProgressHUD.dismiss()
                        }
                    }else{
                        SVProgressHUD.dismiss()
                    }
                }
                else{
                    
                    SVProgressHUD.dismiss()
                    
                    self.mDictUserInfo              = result
                    //mImageViewUser.image          = UIImage( named: "" )
                    self.mLabelUserName.text        = self.mDictUserInfo.value(forKey: "name") as? String
                    self.mLabelPhoneNumber .text    = "\(self.mDictUserInfo.value(forKey: "phone") as! String)"
                    
                    if self.mDictUserInfo.value(forKey: "status") as? String == "pending"{
                        let pendingPopUp           = self.storyboard?.instantiateViewController(withIdentifier: "PendingPopUp") as! PendingPopUp
                        pendingPopUp.delegate      = self
                        self.presentPopupViewController(pendingPopUp, animationType: MJPopupViewAnimationFade)
                    }
                }
            }
        })
        
    }
    
    @IBAction func editAction ( sender : UIButton ) {
        
    }
    
    @IBAction func logoutAction ( sender : UIButton ) {
        
        let logoutAlert = UIAlertController(title: "Are you sure you want to logout ?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        logoutAlert.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { (action: UIAlertAction!) in
            
            self.logout()
        }))
        
        self.present(logoutAlert, animated: true, completion: nil)
    }
    
    func logout () {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.logOut()
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

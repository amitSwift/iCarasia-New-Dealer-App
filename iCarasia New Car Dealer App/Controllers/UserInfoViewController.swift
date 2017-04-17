//
//  UserInfoViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 2/23/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var mTextFieldUserName       : UITextField!
    @IBOutlet weak var mTextFieldEmailAddress   : UITextField!
    
    @IBOutlet weak var mUserTypeSegment         : UISegmentedControl!
    
    var mPhoneNumber    = String()
    var mUSerType       = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "CREATE ACCOUNT"
        
        mUSerType                               = "dealer"
        mUserTypeSegment.selectedSegmentIndex   = 0
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.navigationBarAppearence(navigationController: self.navigationController!)
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userType (_ sender : UISegmentedControl ){
        
        if sender.selectedSegmentIndex == 0 {
            mUSerType   = "dealer"
        }else{
            mUSerType   = "sales_agent"
        }
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func createAccountAction(_ sender: UIButton) {
        
        self.mTextFieldUserName.text            = self.mTextFieldUserName.text?.trimmingCharacters(in: .whitespaces)
        self.mTextFieldEmailAddress.text        = self.mTextFieldEmailAddress.text?.trimmingCharacters(in: .whitespaces)
        
        if mTextFieldUserName.text?.characters.count == 0 {
            TSMessage.showNotification(in: self , title: "\nUser name can't be empty", subtitle: nil, type: TSMessageNotificationType.message)
            return
        }
        else if mTextFieldEmailAddress.text?.characters.count == 0 {
            TSMessage.showNotification(in: self , title: "\nEmail address can't be empty", subtitle: nil, type: TSMessageNotificationType.message)
            return
        }
        else if (!(mTextFieldEmailAddress.text?.isValidEmail)!){
            TSMessage.showNotification(in: self , title: "\nPlease fill a valid Email address.", subtitle: nil, type: TSMessageNotificationType.message)
            return
        }
        

        SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        let servicesManager = ServicesManager()
        let mDictDetails    = NSMutableDictionary()
        mDictDetails.setValue(self.mTextFieldUserName.text!, forKey: "name")
        mDictDetails.setValue(self.mTextFieldEmailAddress.text!, forKey: "email")
        mDictDetails.setValue(self.mUSerType, forKey: "user_type")
        mDictDetails.setValue(self.mPhoneNumber, forKey: "phone")
        
        servicesManager.registerUser(userCredentials: mDictDetails, completion: { (result, error) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                if let token = result.value(forKey: "token") {
                    
                    // Save Token To User Defaults //
                    let toekn = UserDefaults()
                    toekn.set(token, forKey: "iCar_Token")
                    
                    // Save Login Status To User Defaults //
                    let loginStatus = UserDefaults()
                    loginStatus.set(true, forKey: "loginStatus")
                    UserDefaults().synchronize()
                    
                    let vc          = self.storyboard?.instantiateViewController(withIdentifier: "AcComViewController") as! AcComViewController
                    vc.mUserName    = self.mTextFieldUserName.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else  if let eMail = result.value(forKey: "email") {
                    
                    print(eMail)
                    TSMessage.showNotification(in: self , title: "\nThe email has already been taken.", subtitle: nil, type: TSMessageNotificationType.message)
                }
                else  if let phone = result.value(forKey: "phone") {
                    
                    print(phone)
                    TSMessage.showNotification(in: self , title: "\n\(phone)", subtitle: nil, type: TSMessageNotificationType.message)
                }
                else  if let error = result.value(forKey: "error") {
                    
                    print(error)
                    TSMessage.showNotification(in: self , title: "\n\(error).", subtitle: nil, type: TSMessageNotificationType.message)
                }
                
            }
        })
    }
    
    func loginUserOnApplogic ( userName : String ,eMailAddress : String , password : String) {
        
        SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        
        let userID              = userName
        let emailID             = ""
        let password            = password
        
        let alUser : ALUser     = ALUser();
        alUser.applicationId    = ALChatManager.applicationId
        if(ALChatManager.isNilOrEmpty( userID as NSString?)){
            
            let alert           = UIAlertController(title: "Applozic", message: "Please enter userId ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        alUser.userId           = userID
        alUser.displayName      = userID
        alUser.contactNumber    = mPhoneNumber
        ALUserDefaultsHandler.setUserId(alUser.userId)
        
        print("userName:: " , alUser.userId)
        if(!(emailID.isEmpty)){
            alUser.email = emailID
            ALUserDefaultsHandler.setEmailId(alUser.email)
        }
        
        if (!((password.isEmpty))){
            alUser.password = password
            ALUserDefaultsHandler.setPassword(alUser.password)
        }
        
        let chatManager = ALChatManager(applicationKey: "3526295e3bed189cd0a0926c42de6670")
        chatManager.registerUser(alUser) { (response, error) in
            
            SVProgressHUD.dismiss()
            
            let vc          = self.storyboard?.instantiateViewController(withIdentifier: "AcComViewController") as! AcComViewController
            vc.mUserName    = self.mTextFieldUserName.text!
            self.navigationController?.pushViewController(vc, animated: true)
            
            let loginStatus = UserDefaults()
            loginStatus.set(true, forKey: "loginStatus")
            UserDefaults().synchronize()

        }
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

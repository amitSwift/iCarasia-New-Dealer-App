//
//  LoginViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 2/22/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit
import DigitsKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var mLoginButton     : UIButton!
    @IBOutlet weak var mCreateAcButton  : UIButton!
    
    var mPhoneNumber = String()
    
    //var authSignUpButton = DGTAuthenticateButton()
    var authSignInButton = DGTAuthenticateButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Digits.sharedInstance().logOut()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isTranslucent   = false
        self.navigationController?.navigationBar.barTintColor    = UIColor.init(red: (0/255.0), green: (180/255.0), blue: (240/255.0), alpha: 1)
        self.navigationController?.navigationBar.tintColor       = UIColor.white
        
        
        // Do any additional setup after loading the view, typically from a nib. //
        /*authSignInButton = DGTAuthenticateButton(authenticationCompletion: { (session, error) in
            if (session != nil) {
                
                self.mPhoneNumber = session!.phoneNumber.trimmingCharacters(in: .whitespaces)
                self.authenticateUser()
            } else {
                NSLog("Authentication error: %@", error!.localizedDescription)
            }
        })
        
        authSignInButton.setImage(UIImage(named: "text"), for: .normal)
        authSignInButton.setTitle("", for: .normal)
        authSignInButton.backgroundColor = UIColor(red: (0/255.0), green: (180/255.0), blue: (240/255.0), alpha: 1)
        authSignInButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(authSignInButton)
         authSignInButton.digitsAppearance    = self.makeTheme()*/

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        authSignInButton.frame               = self.mLoginButton.frame
        authSignInButton.center              = self.mLoginButton.center
        
        
        //authSignUpButton.frame               = self.mCreateAcButton.frame
        //authSignUpButton.center              = self.mCreateAcButton.center
    }
    
    func makeTheme() -> DGTAppearance {
        
        let theme               = DGTAppearance();
        //theme.bodyFont        = UIFont(name: "Noteworthy-Light", size: 16);
        //theme.labelFont       = UIFont(name: "Noteworthy-Bold", size: 17);
        theme.accentColor       = UIColor.white
        theme.backgroundColor   = UIColor(red: (0/255.0), green: (180/255.0), blue: (240/255.0), alpha: 1)
        // TODO: set a UIImage as a logo with theme.logoImage
        return theme;
    }
    
    @IBAction func authenticateAction (sender : UIButton) {
    
        
        let digits                  = Digits.sharedInstance()
        let configuration           = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask)
        configuration?.phoneNumber  = "+60"
        configuration?.appearance    = self.makeTheme()

        digits.authenticate(with: nil, configuration: configuration!) { session, error in
            
            if (session != nil) {
                
                print("Country selector will be set to Malaysia(+60)")
                print(session?.phoneNumber ?? "Empty Phone Number")
                
                self.mPhoneNumber = session!.phoneNumber.trimmingCharacters(in: .whitespaces)
                
                //let userInfoVC          = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
                //userInfoVC.mPhoneNumber = self.mPhoneNumber //.replacingOccurrences(of: "+", with: "2B")
                //self.navigationController?.pushViewController(userInfoVC, animated: true)
                
                self.authenticateUser()
            } else {
                NSLog("Authentication error: %@", error!.localizedDescription)
            }
        }
    }


    func authenticateUser () {
        
        SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        
        let servicesManager = ServicesManager()
        servicesManager.autheticateUser(parameters: nil, completion: { (result, error) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                if let token = result.value(forKey: "token") {
                    
                    // Save Token To User Defaults //
                    let tokenValue = UserDefaults()
                    tokenValue.set(token, forKey: "iCar_Token")
                    
                    // Save User ID To User Defaults //
                    let userIDValue = UserDefaults()
                    userIDValue.set( result.value(forKey: "id" ), forKey: "current_User_ID")
                    
                    // Save User Type To User Defaults //
                    let userTypeValue = UserDefaults()
                    userTypeValue.set( result.value(forKey: "user_type") , forKey: "current_User_Type")
                    
                    
                    // Save Login Status To User Defaults //
                    let loginStatus = UserDefaults()
                    loginStatus.set(true, forKey: "loginStatus")
                    UserDefaults().synchronize()
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.updateRootController( loginStatus: true )
                    
                    //self.loginUserOnApplogic(userName: self.mTextFieldUserName.text!, eMailAddress: self.mTextFieldEmailAddress.text! , password: "12345678")
                }else{
                    
                     //TSMessage.showNotification(in: self , title: "\n\(result.value(forKey: "message") as! String)", subtitle: nil, type: TSMessageNotificationType.message)
                    
                    print("User Not Found !")
                    
                    let userInfoVC          = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
                    userInfoVC.mPhoneNumber = self.mPhoneNumber
                    self.navigationController?.pushViewController(userInfoVC, animated: true)
                }
            }
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

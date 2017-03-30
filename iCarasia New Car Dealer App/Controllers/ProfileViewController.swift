
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
    @IBOutlet weak var mCameraButton        : UIButton!
    @IBOutlet weak var mTextFieldUserName   : UITextField!
    @IBOutlet weak var mLabelPhoneNumber    : UILabel!
    
    var mDictUserInfo = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view. //
        
        self.title                  = "Profile"
        self.navigationItem.title   = "PROFILE"
        self.mCameraButton.isHidden                      = true
        self.mTextFieldUserName.isUserInteractionEnabled = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         if let userName = self.mDictUserInfo.value(forKey: "name") as? String {
            print("User Name = \(userName)")
        }else{
            self.profile()
        }
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
                    self.mTextFieldUserName.text    = self.mDictUserInfo.value(forKey: "name") as? String
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
        
        self.mCameraButton.isHidden                      = false
        self.mTextFieldUserName.isUserInteractionEnabled = true
        self.mTextFieldUserName.becomeFirstResponder()
    }
    
    @IBAction func cameraAction ( sender : UIButton ) {
        
        let alert           = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction    = UIAlertAction(title: "Camera", style: .default) {
            (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                
                let imagePicker                         = UIImagePickerController()
                imagePicker.navigationController?.navigationBar.barTintColor  = UIColor(red: 218.0/255.0, green: 67.0/255.0, blue: 20.0/255.0, alpha: 1.0)
                imagePicker.navigationController?.navigationBar.tintColor     = UIColor.white
                imagePicker.delegate                    = self
                imagePicker.sourceType                  = UIImagePickerControllerSourceType.camera;
                imagePicker.mediaTypes                  = [kUTTypeImage as String]
                imagePicker.allowsEditing               = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let libraryAction   = UIAlertAction(title: "Library", style: .default) {
            (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                
                let imagePicker                         = UIImagePickerController()
                imagePicker.navigationController?.navigationBar.barTintColor  = UIColor(red: 218.0/255.0, green: 67.0/255.0, blue: 20.0/255.0, alpha: 1.0)
                imagePicker.navigationController?.navigationBar.tintColor     = UIColor.white
                imagePicker.delegate                    = self
                imagePicker.sourceType                  = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.mediaTypes                  = [kUTTypeImage as String]
                imagePicker.allowsEditing               = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction    = UIAlertAction(title: "Cancel", style: .cancel) {
            (action: UIAlertAction) in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.mImageViewUser.image = image
            let resizedImage          = image.resizeWith(width: 250)
            //let mImageData            = UIImagePNGRepresentation(resizedImage!)! as NSData
            //let mStrBase64            = mImageData.base64EncodedString(options:.lineLength64Characters) as String
            
        }
        picker.dismiss(animated: true, completion: nil)
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

extension UIImage {
    
    func resizeWith(percentage: CGFloat) -> UIImage? {
        
        let imageView           = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode   = .scaleAspectFit
        imageView.image         = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context       = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result        = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWith(width: CGFloat) -> UIImage? {
        
        let imageView           = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode   = .scaleAspectFit
        imageView.image         = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context       = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result        = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

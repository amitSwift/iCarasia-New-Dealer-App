
//
//  CreateOfferViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class CreateOfferViewController: UIViewController , UITextViewDelegate ,MJCreateOfferPopupDelegate{
    
    internal func cancelButtonClickedCreateOffer(_ secondDetailViewController: CreateOfferPopUpVC ) {
        
        print("Cross Clicked")
        
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    internal func tickButtonClickedCreateOffer(_ secondDetailViewController: CreateOfferPopUpVC ) {
        
        print("Tick Clicked")
        
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        self.addEditOffer()
    }

    
    
    @IBOutlet weak var mVariantLabel        : UILabel!
    @IBOutlet weak var mTextViewOffer       : UITextView!
    @IBOutlet weak var mLabelCharCount      : UILabel!
    
    
    var mVarientString      = String()
    var mDealershipID       = NSNumber()
    var mModelID            = NSNumber()
    var mVehicleID          = NSNumber()
    
    var mOfferInfo          = NSDictionary()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "CREATE OFFER"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        mVariantLabel.text = mVarientString
        
        self.getOffer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction ( sender : UIButton) {
        
        self.view.endEditing(true)
        let createOfferPopUp           = self.storyboard?.instantiateViewController(withIdentifier: "CreateOfferPopUpVC") as! CreateOfferPopUpVC
        createOfferPopUp.delegate      = self
        self.presentPopupViewController(createOfferPopUp, animationType: MJPopupViewAnimationFade)

        
        
    }
    
    func getOffer () {
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue(self.mDealershipID, forKey: "dealership_ID")
        parmDict.setValue(self.mModelID, forKey: "model_ID")
        parmDict.setValue(self.mVehicleID, forKey: "vehicle_ID")
        
        servicesManager.getOffer(parameters: parmDict, completion: { (result, error) in
            DispatchQueue.main.async {
                
                if result.value(forKey: "offer") is NSNull {
                    SVProgressHUD.dismiss()
                    //TSMessage.showNotification(in: self , title: "\n An error encounterd while loading data! Please try again.", subtitle: nil, type: TSMessageNotificationType.message)
                    return;
                }
                
                if result.value(forKey: "offer") is NSDictionary {
                    
                    SVProgressHUD.dismiss()
                    self.mOfferInfo          = result.value(forKey: "offer") as! NSDictionary
                    self.mTextViewOffer.text = self.mOfferInfo.value(forKey: "autoresponse_message") as! String
                    //self.mLabelCharCount.text = "\(250 - self.mTextViewOffer.text.characters.count)"
                    
                    
                }else{
                    
                    TSMessage.showNotification(in: self , title: "\n\(result.value(forKey: "error") as! String)", subtitle: nil, type: TSMessageNotificationType.message)
                    
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
                                        self.getOffer()
                                    }
                                }
                            })
                        }
                    }
                    
                }
                
            }
        })
    }
    
    func addEditOffer () {
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue(self.mDealershipID, forKey: "dealership_ID")
        parmDict.setValue(self.mModelID, forKey: "model_ID")
        parmDict.setValue(self.mVehicleID, forKey: "vehicle_ID")
        parmDict.setValue(self.mTextViewOffer.text!, forKey: "autoresponse_message")
        
        
        servicesManager.addOffer(parameters: parmDict, completion: { (result, error) in
            DispatchQueue.main.async {
                
                
                
                if result.value(forKey: "offer") is NSDictionary {
                    
                    SVProgressHUD.dismiss()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferComViewController") as! OfferComViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    
                    TSMessage.showNotification(in: self , title: "\n\(result.value(forKey: "error") as! String)", subtitle: nil, type: TSMessageNotificationType.message)
                    
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
                                        self.addEditOffer()
                                    }
                                }
                            })
                        }
                    }
                    
                }
                
            }
        })
    }

    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        let currentCharacterCount = textView.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength  = currentCharacterCount + text.characters.count - range.length
        /*
        if text == "" && range.length > 0 {
            if let oldCount  = Int(self.mLabelCharCount.text!) {
                let newCount = oldCount + range.length
                self.mLabelCharCount.text   = "\(newCount)"
            }
            
        }else if text != "" && range.location < 250{
            if let oldCount  = Int(self.mLabelCharCount.text!) {
                let newCount = oldCount - text.characters.count
                self.mLabelCharCount.text   = "\(newCount)"
            }
        }*/
        return newLength <= 250
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

//
//  OffersModelViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class OffersModelViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var mTableVarientsList       : UITableView!
    @IBOutlet weak var mLabelError              : UILabel!
    
    var mArrayVariants      = NSArray()
    var mDealershipID       = NSNumber()
    var mModelID            = NSNumber()
    var mTitle              = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "\(mTitle.uppercased()) MODELS"
        self.navigationItem.backBarButtonItem   = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.mTableVarientsList.tableFooterView = UIView()
        self.getVarients()
        
        self.mLabelError.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVarients () {
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue(self.mDealershipID, forKey: "delaership_id")
        parmDict.setValue(self.mModelID, forKey: "model_id")
        servicesManager.variants(parameters: parmDict, completion: { (result, error) in
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                if result.value(forKey: "vehicles") is NSArray {
                    
                    self.mArrayVariants = result.value(forKey: "vehicles") as! NSArray
                    if self.mArrayVariants.count == 0 {
                        self.mLabelError.isHidden = false
                    }
                    self.mTableVarientsList.reloadData()
                    
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
                                        self.getVarients()
                                    }
                                }
                            })
                        }
                    }
                    
                }
                
            }
        })
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.mArrayVariants.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        let labelVarient                     = cell.viewWithTag(1) as! UILabel
        labelVarient.text                    = (self.mArrayVariants.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String?
        
        let buttonCreateOffer                = cell.viewWithTag(2) as! UIButton
        buttonCreateOffer.layer.cornerRadius = 3
        buttonCreateOffer.layer.borderColor  = UIColor.init(red: 0/255.0, green: 180/255.0, blue: 242/255.0, alpha: 1.0).cgColor
        buttonCreateOffer.layer.borderWidth  = 1.0
        
        buttonCreateOffer.addTarget(self, action: #selector(createOffer(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateOfferViewController") as! CreateOfferViewController
        
        let dictInfo        = self.mArrayVariants.object(at: indexPath.row) as! NSDictionary
        
        vc.mDealershipID    = self.mDealershipID
        vc.mModelID         = self.mModelID
        vc.mVarientString   = dictInfo.value(forKey: "name") as! String
        vc.mVehicleID       = dictInfo.value(forKey: "id") as! NSNumber
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func createOffer ( sender : UIButton) {
        
        let buttonPosition          = sender.convert(CGRect(), to: self.mTableVarientsList)
        var indexPath: IndexPath?   = self.mTableVarientsList.indexPathForRow(at: CGPoint(x: buttonPosition.origin.x, y: buttonPosition.origin.y))
        let dictInfo                = self.mArrayVariants.object(at: (indexPath?.row)!) as! NSDictionary

        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateOfferViewController") as! CreateOfferViewController
        vc.mDealershipID    = self.mDealershipID
        vc.mModelID         = self.mModelID
        vc.mVarientString   = dictInfo.value(forKey: "name") as! String
        vc.mVehicleID       = dictInfo.value(forKey: "id") as! NSNumber
        self.navigationController?.pushViewController(vc, animated: true)
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

//
//  BrandOffersViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class BrandOffersViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var mTableBrandList       : UITableView!
    
    var mArrayModels = NSArray()
    
    var mDealerShipID     = NSNumber()
    var mTitle      = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "\(mTitle.uppercased()) OFFERS"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.mTableBrandList.tableFooterView  = UIView()
        
        self.getModels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getModels () {
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue(self.mDealerShipID, forKey: "dealership_id")

        servicesManager.models(parameters: parmDict, completion: { (result, error) in
            DispatchQueue.main.async {
                
                
                if result.value(forKey: "models") is NSArray {
                    SVProgressHUD.dismiss()
                    self.mArrayModels = result.value(forKey: "models") as! NSArray
                    self.mTableBrandList.reloadData()
                    
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
                                        self.getModels()
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
        return mArrayModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        let modelInfoDict                   = self.mArrayModels.object(at: indexPath.row) as! NSDictionary
        
        let labelModel                      = cell.viewWithTag(1) as! UILabel
        labelModel.text                     = modelInfoDict.value(forKey: "name") as? String
        
        let buttonViewOffer                 = cell.viewWithTag(2) as! UIButton
        buttonViewOffer.layer.cornerRadius  = 3
        buttonViewOffer.layer.borderColor   = UIColor.init(red: 0/255.0, green: 180/255.0, blue: 242/255.0, alpha: 1.0).cgColor
        buttonViewOffer.layer.borderWidth   = 1.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc              = self.storyboard?.instantiateViewController(withIdentifier: "OffersModelViewController") as! OffersModelViewController
        let modelInfoDict   = self.mArrayModels.object(at: indexPath.row) as! NSDictionary
        
        vc.mDealershipID    = self.mDealerShipID
        vc.mModelID         = modelInfoDict.value(forKey: "id") as! NSNumber
        
        vc.mTitle           = self.mTitle + " \(modelInfoDict.value(forKey: "name") as! String)"
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

//
//  OffersViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/2/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class OffersViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var mTableViewOffers       : UITableView!
    
    var mArrayDealerships = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title                  = "Offers"
        self.navigationItem.title   = "OFFERS"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.mTableViewOffers.tableFooterView = UIView()
        
        self.getDealerships()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getDealerships () {
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        servicesManager.dealershipsList(parameters: nil, completion: { (result, error) in
            DispatchQueue.main.async {
                
                
                
                if result.value(forKey: "dealerships") is NSArray {
                    SVProgressHUD.dismiss()
                    self.mArrayDealerships = result.value(forKey: "dealerships") as! NSArray
                    self.mTableViewOffers.reloadData()
                }
                else{
                    
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
                                        self.getDealerships()
                                    }
                                }
                            })
                        }
                    }else{
                        SVProgressHUD.dismiss()
                    }
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.mArrayDealerships.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        let dealershipInfo          = self.mArrayDealerships.object(at: indexPath.row) as! NSDictionary
        //let dealershipIcon          = cell.viewWithTag(1) as! UIImageView
        let dealershipNameLabel     = cell.viewWithTag(2) as! UILabel
        let dealershipMakeLabel     = cell.viewWithTag(3) as! UILabel
        
        dealershipNameLabel.text    = dealershipInfo.value(forKey: "name") as! String?
        dealershipMakeLabel.text    = dealershipInfo.value(forKeyPath: "make.name") as! String?
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc              = self.storyboard?.instantiateViewController(withIdentifier: "BrandOffersViewController") as! BrandOffersViewController
        let dealershipInfo  = self.mArrayDealerships.object(at: indexPath.row) as! NSDictionary
        vc.mDealerShipID    = dealershipInfo.value(forKey: "id") as! NSNumber
        vc.mTitle           = dealershipInfo.value(forKeyPath: "make.name") as! String

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

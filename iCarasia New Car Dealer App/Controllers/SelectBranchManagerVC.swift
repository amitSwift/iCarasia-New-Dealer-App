//
//  SelectBranchManagerVC.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/27/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class SelectBranchManagerVC: UIViewController , UITableViewDelegate , UITableViewDataSource,MJChangeBMPopupDelegate {
    
    internal func cancelButtonClickedSelectBranchManager(_ secondDetailViewController: ChangeBranchManagerPopUpVC) {
        print("Cross Clicked")
        
        self.mTableAgentsList.deselectRow(at: self.mTableAgentsList.indexPathForSelectedRow!, animated: true)
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    
    internal func tickButtonClickedSelectBranchManager(_ secondDetailViewController: ChangeBranchManagerPopUpVC) {
        print("Tick Clicked")
        self.changeManager()
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    
    @IBOutlet weak var mTableAgentsList             : UITableView!
    
    var mArrayAgents    = NSArray()
    
    var mDealerID       = NSNumber()
    var mAgentID        = NSNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title                  = "Agents"
        self.navigationItem.title   = "AGENTS"
        self.navigationController?.navigationBar.backItem?.title    = "SELECT"
        self.navigationItem.backBarButtonItem                       = UIBarButtonItem(title: "SELECT", style: .plain, target: nil, action: nil)
        
        //let userIDValue = UserDefaults()
        //self.mDealerID = userIDValue.value(forKey: "current_User_ID") as! NSNumber
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mArrayAgents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell  = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        
        let mCheckImageView  = cell.viewWithTag(1) as! UIImageView
        let mUserImageView   = cell.viewWithTag(2) as! UIImageView
        let mUserNameLabel   = cell.viewWithTag(3) as! UILabel
        let mUserPhoneLabel  = cell.viewWithTag(4) as! UILabel
        
        let dictInfo                = self.mArrayAgents.object(at: indexPath.row) as! NSDictionary
        
        if let name = dictInfo.value(forKeyPath: "user.name") {
            mUserNameLabel.text     = name as? String
        }else{
            mUserNameLabel.text     = ""
        }
        
        if let phone = dictInfo.value(forKeyPath: "user.phone") {
            mUserPhoneLabel.text    = phone as? String
        }else{
            mUserPhoneLabel.text    = ""
        }
        
        if let thumb = dictInfo.value(forKeyPath: "user.profile_image_thumb_url") {
            mUserImageView.setImageWith(URL(string: (thumb as? String)!), usingActivityIndicatorStyle: .gray)
        }
        
        
        if dictInfo.value(forKey: "is_branch_manager") as! NSNumber == 1 {
            mUserNameLabel.textColor        = UIColor.lightGray
            mUserPhoneLabel.textColor       = UIColor.lightGray
            mCheckImageView.isHidden        = true
            cell.isUserInteractionEnabled   = false
        }else{
            mUserNameLabel.textColor        = UIColor.black
            mUserPhoneLabel.textColor       = UIColor.black
            mCheckImageView.isHidden        = false
            cell.isUserInteractionEnabled   = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell                        = tableView.cellForRow(at: indexPath)
        let mCheckImageView             = cell?.viewWithTag(1) as! UIImageView
        mCheckImageView.isHighlighted   = true
        
        
        let dictInfo                    = self.mArrayAgents.object(at: indexPath.row) as! NSDictionary
        self.mDealerID                  = dictInfo.value(forKey: "dealer_id") as! NSNumber
        self.mAgentID                   = dictInfo.value(forKey: "user_id") as! NSNumber

        let secondDetailViewController = storyboard?.instantiateViewController(withIdentifier: "ChangeBranchManagerPopUpVC")as! ChangeBranchManagerPopUpVC
        secondDetailViewController.delegate = self
        self.presentPopupViewController(secondDetailViewController, animationType: MJPopupViewAnimationFade)
    }
    
    func changeManager () {
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue(self.mDealerID, forKey: "dealer_ID")
        parmDict.setValue(self.mAgentID, forKey: "agent_ID")
        
        servicesManager.changeManager(parameters: parmDict, completion: { (result, error) in
            DispatchQueue.main.async {
                
                if result.value(forKey: "branch_manager") is NSDictionary {
                    
                    SVProgressHUD.dismiss()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh_Agents_List"), object: nil)
                    _ = self.navigationController?.popViewController(animated: true)
                    
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
                                        self.changeManager()
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
                
            }
        })
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

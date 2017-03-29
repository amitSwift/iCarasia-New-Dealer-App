//
//  AgentsViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/2/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class AgentsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate ,MJPopUpPopupDelegate,MJAddConfirmPopupDelegate{
    
    internal func cancelButtonClickedAddAgent(_ secondDetailViewController: AddAgentPopUpVC , number: String) {
        
        print("Cross Clicked")
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    
    internal func cancelButtonClickedAddAgentConfirm(_ secondDetailViewController: AddAgentConfirmVC) {
        
        print("Cross Clicked")
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        self.agentsList()
    }
    
    internal func rightButtonClickedAddAgent(_ secondDetailViewController: AddAgentPopUpVC , number: String) {
       
        print("Right Clicked")
        self.mPhoneNumber = number
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        self.perform(#selector(addAgent), with: nil, afterDelay: 0.5)
    }

    
    @IBOutlet weak var mLabelBrachManagerName       : UILabel!
    @IBOutlet weak var mTableAgentsList             : UITableView!
    
    var mBranchManagerInfo      = NSDictionary()
    var mArrayAgentsList        = NSArray()
    var mDealershipID           = NSNumber()
    var mPhoneNumber            = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title                  = "Agents"
        self.navigationItem.title   = "AGENTS"
        self.navigationController?.navigationBar.backItem?.title    = ""
        self.navigationItem.backBarButtonItem                       = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
        self.agentsList()
        NotificationCenter.default.addObserver(self, selector: #selector(agentsList), name: NSNotification.Name(rawValue: "refresh_Agents_List"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refresh_Agents_List"), object: nil)
    }
    
    @IBAction func changeBranchManager ( sender : UIButton) {
        
        Swift.print("Change Manager Method Called")
        
        let selectBranchManagerVC           = storyboard?.instantiateViewController(withIdentifier: "SelectBranchManagerVC")as! SelectBranchManagerVC
        selectBranchManagerVC.mArrayAgents  = self.mArrayAgentsList
        self.navigationController?.pushViewController(selectBranchManagerVC, animated: true)
    }
    
    
    func agentsList () {
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue(mDealershipID, forKey: "dealership_ID")
        servicesManager.salesAgentsList(parameters: parmDict, completion: { (result, error) in
            DispatchQueue.main.async {
                
                
                if result.value(forKey: "sales_agents") is NSArray {
                    
                    SVProgressHUD.dismiss()
                    
                    self.mArrayAgentsList               = result.value(forKey: "sales_agents") as! NSArray
                    self.mBranchManagerInfo             = result.value(forKey: "branch_manager") as! NSDictionary
                    
                    self.mLabelBrachManagerName.text    = self.mBranchManagerInfo.value(forKey: "name") as! String?
                    
                    self.mTableAgentsList.reloadData()
                    
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
                                        self.agentsList()
                                    }
                                }
                            })
                        }
                    }
                }
            }
        })
    }
    
    func addAgent () {
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue(mDealershipID, forKey: "dealership_ID")
        parmDict.setValue(self.mPhoneNumber, forKey: "phone")
        servicesManager.addAgent(parameters: parmDict, completion: { (result, error) in
            
            DispatchQueue.main.async {
                
                if let resultValue = result.value(forKey: "sales_agent") {
                    
                    SVProgressHUD.dismiss()
                    
                    print(resultValue)
                    //self.mArrayAgentsList = result.value(forKey: "sales_agents") as! NSArray
                    //self.mTableAgentsList.reloadData()
                    
                    let addAgentConfirmVC           = self.storyboard?.instantiateViewController(withIdentifier: "AddAgentConfirmVC") as! AddAgentConfirmVC
                    addAgentConfirmVC.delegate      = self
                    addAgentConfirmVC.mPhoneNumber  = self.mPhoneNumber
                    self.presentPopupViewController(addAgentConfirmVC, animationType: MJPopupViewAnimationFade)
                    
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
                                        self.addAgent()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mArrayAgentsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell  = tableView.dequeueReusableCell(withIdentifier: "agentsCell", for: indexPath)
        
        
        let dictInfo                = self.mArrayAgentsList.object(at: indexPath.row) as! NSDictionary
        
        //let imageView               = cell.viewWithTag(1) as! UIImageView
        //imageView.image             = UIImage (named: "")
        
        let labelName               = cell.viewWithTag(2) as! UILabel
        if let name = dictInfo.value(forKeyPath: "user.name") {
            labelName.text              = name as? String
        }else{
            labelName.text              = dictInfo.value(forKeyPath: "user.phone") as? String
        }
        
        
        let switchValue             = cell.viewWithTag(3) as! UISwitch
        switchValue.transform       = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AgentProfileViewController") as! AgentProfileViewController
        vc.mAgentInfoDict = self.mArrayAgentsList.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func AddAgentAction(_ sender: AnyObject) {
        
        let secondDetailViewController = storyboard?.instantiateViewController(withIdentifier: "AddAgentPopUpVC")as! AddAgentPopUpVC
        secondDetailViewController.delegate = self
        self.presentPopupViewController(secondDetailViewController, animationType: MJPopupViewAnimationFade)
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

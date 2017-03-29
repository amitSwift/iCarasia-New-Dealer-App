//
//  AgentProfileViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/15/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class AgentProfileViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    
    @IBOutlet weak var mTableAgents             : UITableView!
    
    @IBOutlet weak var mViewHeader              : UIView!
    @IBOutlet weak var mImageViewAgent          : UIImageView!
    @IBOutlet weak var mLableAgentName          : UILabel!
    @IBOutlet weak var mLabelAgentInfo          : UILabel!
    
    var mAgentInfoDict     = NSDictionary()
    var mArrayAgentInfo    = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let deleteButtonItem    = UIBarButtonItem.init(image: UIImage(named:"delete"), style: .plain, target: self, action: #selector(deleteAction))
        self.navigationItem.rightBarButtonItems = [deleteButtonItem]
        
        self.setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        let frame : CGRect!
        if let shortBio  = mAgentInfoDict.value(forKeyPath: "user.short_bio") as? String{
            print(" Short Bio :\(shortBio)")
            frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 280)
        }else{
            frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 220)
        }
        mViewHeader.frame = frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI () {
        
        print("Dealership Info : \(mAgentInfoDict)")
        
        if let userName  = mAgentInfoDict.value(forKeyPath: "user.name") as? String {
            mLableAgentName.text    = userName
        }
        
        if let shortBio  = mAgentInfoDict.value(forKeyPath: "user.short_bio") as? String{
            mLabelAgentInfo.text    = shortBio
        }else{
            mLabelAgentInfo.text    = ""
        }
        
        
        
        // First Section //
        
        let arrayFirstSection = NSMutableArray()
        
        if let phoneNumber  = mAgentInfoDict.value(forKeyPath: "user.phone") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(phoneNumber, forKey: "phone_number")
            arrayFirstSection.add(tempDict)
        }
        
        if let website      = mAgentInfoDict.value(forKeyPath: "user.website") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(website, forKey: "website")
            arrayFirstSection.add(tempDict)
        }
        
        if let address      = mAgentInfoDict.value(forKeyPath: "user.address") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(address, forKey: "address")
            arrayFirstSection.add(tempDict)
        }
        
        mArrayAgentInfo.add(arrayFirstSection)
        
        // Second Section //
        
        let arraySecondSection = NSMutableArray()
        
        if let facebook  = mAgentInfoDict.value(forKeyPath: "user.facebook") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(facebook, forKey: "facebook")
            arraySecondSection.add(tempDict)
        }
        
        if let instagram      = mAgentInfoDict.value(forKeyPath: "user.instagram") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(instagram, forKey: "instagram")
            arraySecondSection.add(tempDict)
        }
        
        if let google_plus      = mAgentInfoDict.value(forKeyPath: "user.google_plus") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(google_plus, forKey: "google_plus")
            arraySecondSection.add(tempDict)
        }
        
        if let twitter      = mAgentInfoDict.value(forKeyPath: "user.twitter") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(twitter, forKey: "twitter")
            arraySecondSection.add(tempDict)
        }
        
        if let whatsapp      = mAgentInfoDict.value(forKeyPath: "user.whatsapp") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(whatsapp, forKey: "whatsapp")
            arraySecondSection.add(tempDict)
        }
        mArrayAgentInfo.add(arraySecondSection)
        self.mTableAgents.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return mArrayAgentInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if section == 0 {
            return (mArrayAgentInfo.object(at: section) as! NSArray).count
        }else{
            return (mArrayAgentInfo.object(at: section) as AnyObject).count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.section == 0 {
            return self.configureCellForFirstSectionWithIndexPath(indexPath: indexPath)
        }
        else{
            return self.configureCellForSecondSectionWithIndexPath(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view                    = UIView()
        view.backgroundColor        = UIColor.white
        
        let imageView               = UIImageView(frame: CGRect(x: 12, y: 9, width: self.view.frame.width - 24, height: 1))
        imageView.backgroundColor   = UIColor.lightGray
        imageView.alpha             = 0.75
        view.addSubview(imageView)
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func configureCellForFirstSectionWithIndexPath ( indexPath : IndexPath ) -> UITableViewCell {
        
        var cellIdentifier  : String!
        var cell            : UITableViewCell!
        
        let dictDetails     = (self.mArrayAgentInfo.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary
        var titleValue      : String!
        
        switch dictDetails.allKeys[0] as! String {
        case "phone_number":
            cellIdentifier  = "phoneCell"
            titleValue      = dictDetails.value(forKey: "phone_number") as! String!
            break
        case "website":
            cellIdentifier  = "websiteCell"
            titleValue      = dictDetails.value(forKey: "website") as! String!
            break
        case "address":
            cellIdentifier  = "locationCell"
            titleValue      = dictDetails.value(forKey: "address") as! String!
            break
        default:
            break
        }
        
        cell                = self.mTableAgents.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let mTextLabel      = cell.viewWithTag(2) as! UILabel
        mTextLabel.text     = titleValue
        
        return cell
    }
    
    func configureCellForSecondSectionWithIndexPath ( indexPath : IndexPath ) -> UITableViewCell {
        
        
        var cellIdentifier  : String!
        var cell            : UITableViewCell!
        let dictDetails     = (self.mArrayAgentInfo.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary
        var image           : String!
        var title           : String!
        var titleInfo       : String!
        
        switch dictDetails.allKeys[0] as! String {
        case "facebook":
            image = "facebook"
            title = "Facebook"
            titleInfo = dictDetails.value(forKey: "facebook") as! String
            break
        case "instagram":
            image = "instagram"
            title = "Instagram"
            titleInfo = dictDetails.value(forKey: "instagram") as! String
            break
        case "google_plus":
            image = "google-plus"
            title = "Google +"
            titleInfo = dictDetails.value(forKey: "google_plus") as! String
            break
        case "twitter":
            image = "twitter"
            title = "Twitter"
            titleInfo = dictDetails.value(forKey: "twitter") as! String
            break
        case "whatsapp":
            image = "whatsapp"
            title = "Whatsapp"
            titleInfo = dictDetails.value(forKey: "whatsapp") as! String
            break
        default:
            break
        }
        
        cellIdentifier      = "socialCell"
        cell                = self.mTableAgents.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        
        let imageView       = cell.viewWithTag(1) as! UIImageView
        imageView.image     = UIImage(named: image)
        
        let mTextLabel      = cell.viewWithTag(2) as! UILabel
        mTextLabel.text     = title
        
        let mTextLabelInfo  = cell.viewWithTag(3) as! UILabel
        mTextLabelInfo.text = titleInfo
        
        return cell
    }
    
    func deleteAction() {
        
        print("Edit Button Pressed")
        let deleteAlert = UIAlertController(title: "You want to delete Agent : \(mAgentInfoDict.value(forKeyPath: "user.name")!)", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        deleteAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { (action: UIAlertAction!) in
            
            self.deleteAgent()
        }))
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    
    func deleteAgent (){
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue(self.mAgentInfoDict.value(forKey: "id")!, forKey: "dealer_id")
        parmDict.setValue(self.mAgentInfoDict.value(forKey: "id")!, forKey: "sales_Agent_id")
        servicesManager.deleteAgent(parameters: parmDict, completion: { (result, error) in
            
            DispatchQueue.main.async {
                
                if let error =  result.value(forKey: "error") {
                    
                    print(error)
                    TSMessage.showNotification(in: self , title: "\n\(result.value(forKey: "error") as! String)", subtitle: nil, type: TSMessageNotificationType.message)
                    
                    if error as! String == "Unauthenticated." {
                        
                        //SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
                        let servicesManager = ServicesManager()
                        servicesManager.autheticateUser(parameters: nil, completion: { (result, error) in
                            
                            DispatchQueue.main.async {
                                //SVProgressHUD.dismiss()
                                if let token = result.value(forKey: "token") {
                                    
                                    // Save Token To User Defaults //
                                    let tokenValue = UserDefaults()
                                    tokenValue.set(token, forKey: "iCar_Token")
                                    self.deleteAgent()
                                }
                            }
                        })
                    }else{
                        SVProgressHUD.dismiss()
                    }
                }else{
                    
                    SVProgressHUD.dismiss()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh_Agents_List"), object: nil)
                    _ = self.navigationController?.popViewController(animated: true)
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

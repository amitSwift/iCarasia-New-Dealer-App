//
//  DealershipDetailsViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class DealershipDetailsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var mTableDealerShipDetails       : UITableView!
    @IBOutlet weak var mViewHeader                   : UIView!
    
    @IBOutlet weak var mImageViewDealership          : UIImageView!
    @IBOutlet weak var mLabelDealershipTitle         : UILabel!
    @IBOutlet weak var mLabelDealershipMake          : UILabel!
    @IBOutlet weak var mLabelDealershipInfo          : UILabel!
    
    
    var mDealershipInfoDict     = NSDictionary()
    var mArrayDealershipInfo    = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let userStatus          = UserDefaults()
        let userType            = userStatus.value(forKey: "current_User_Type") as! String
        if userType == "dealer"{
        
            let editButtonItem      = UIBarButtonItem.init(image: UIImage(named:"edit_white"), style: .plain, target: self, action: #selector(editAction))
            //let deleteButtonItem    = UIBarButtonItem.init(image: UIImage(named:"delete"), style: .plain, target: self, action: #selector(deleteAction))
            self.navigationItem.rightBarButtonItems = [editButtonItem]
        }
        
        
        self.setupUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        mViewHeader.frame = frame
    }
    
    func setupUI () {
        
        print("Dealership Info : \(mDealershipInfoDict)")
        
        mLabelDealershipTitle.text = mDealershipInfoDict.value(forKey: "name") as! String?
        mLabelDealershipMake.text  = mDealershipInfoDict.value(forKeyPath: "make.name") as! String?
        //mLabelDealershipInfo.text  = ""
        // First Section //
        
        let arrayFirstSection = NSMutableArray()
        
        if let phoneNumber  = mDealershipInfoDict.value(forKey: "phone_number") {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(phoneNumber, forKey: "phone_number")
            arrayFirstSection.add(tempDict)
        }
        
        if let website      = mDealershipInfoDict.value(forKey: "website") {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(website, forKey: "website")
            arrayFirstSection.add(tempDict)
        }
        
        if let address      = mDealershipInfoDict.value(forKey: "address") {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(address, forKey: "address")
            arrayFirstSection.add(tempDict)
        }
        
        mArrayDealershipInfo.add(arrayFirstSection)
        
        // Second Section //
        
        let arraySecondSection = NSMutableArray()
        
        if let facebook  = mDealershipInfoDict.value(forKey: "facebook") {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(facebook, forKey: "facebook")
            arraySecondSection.add(tempDict)
        }
        
        if let instagram      = mDealershipInfoDict.value(forKey: "instagram") {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(instagram, forKey: "instagram")
            arraySecondSection.add(tempDict)
        }
        
        if let google_plus      = mDealershipInfoDict.value(forKey: "google_plus") {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(google_plus, forKey: "google_plus")
            arraySecondSection.add(tempDict)
        }
        
        if let twitter      = mDealershipInfoDict.value(forKey: "twitter") {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(twitter, forKey: "twitter")
            arraySecondSection.add(tempDict)
        }
        
        if let whatsapp      = mDealershipInfoDict.value(forKey: "whatsapp") {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(whatsapp, forKey: "whatsapp")
            arraySecondSection.add(tempDict)
        }
        mArrayDealershipInfo.add(arraySecondSection)
        self.mTableDealerShipDetails.reloadData()
        
    }
    
    func editAction() {
        
        print("Edit Button Pressed")
    }
    
    func deleteAction() {
        
        print("Edit Button Pressed")
        
        let deleteAlert = UIAlertController(title: "You want to delete dealership : \(mDealershipInfoDict.value(forKey: "name")!)", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        deleteAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { (action: UIAlertAction!) in
            
            self.deleteDealership()
        }))
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    func deleteDealership () {
        
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue(self.mDealershipInfoDict.value(forKey: "id")!, forKey: "dealer_id")
        parmDict.setValue(self.mDealershipInfoDict.value(forKeyPath: "user.id")!, forKey: "sales_Agent_id")
        servicesManager.deleteDealerships(parameters: parmDict, completion: { (result, error) in
            
            DispatchQueue.main.async {
                
                
                if let value = result.value(forKey: "dealerships")  {
                    
                    print("Delete Dealership Result = \(value)")
                    SVProgressHUD.dismiss()
                    
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
                                        self.deleteDealership()
                                    }
                                }
                            })
                        }else{
                            SVProgressHUD.dismiss()
                        }
                    }else{
                        SVProgressHUD.dismiss()
                    }
                }
                
            }
        })

    }
    
    // MARK: - Table View Methods -
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return mArrayDealershipInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if section == 0 {
            return (mArrayDealershipInfo.object(at: section) as AnyObject).count
        }else{
            return (mArrayDealershipInfo.object(at: section) as AnyObject).count
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
        
        let dictDetails     = (self.mArrayDealershipInfo.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary
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
        
        cell                = self.mTableDealerShipDetails.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let mTextLabel      = cell.viewWithTag(2) as! UILabel
        mTextLabel.text     = titleValue
        
        return cell
    }
    
    func configureCellForSecondSectionWithIndexPath ( indexPath : IndexPath ) -> UITableViewCell {
        
        
        var cellIdentifier  : String!
        var cell            : UITableViewCell!
        let dictDetails     = (self.mArrayDealershipInfo.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary
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
        cell                = self.mTableDealerShipDetails.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        
        let imageView       = cell.viewWithTag(1) as! UIImageView
        imageView.image     = UIImage(named: image)
        
        let mTextLabel      = cell.viewWithTag(2) as! UILabel
        mTextLabel.text     = title
        
        let mTextLabelInfo  = cell.viewWithTag(3) as! UILabel
        mTextLabelInfo.text = titleInfo
        
        return cell
    }
    
    
    @IBAction func addDeralerShip ( sender : UIButton ){
        
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

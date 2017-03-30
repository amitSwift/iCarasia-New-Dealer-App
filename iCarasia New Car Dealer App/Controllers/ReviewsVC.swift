//
//  ReviewsVC.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class ReviewsVC: UITableViewController,MJSecondPopupDelegate {
    
    internal func cancelButtonClicked(_ secondDetailViewController: ReviewFilterVC) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }

    @IBOutlet var tableReview: UITableView!
    
    var mDealerShipID = NSNumber()
    
    var mArrayReviews = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableReview.estimatedRowHeight = 260.0;
        self.tableReview.rowHeight = UITableViewAutomaticDimension;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "REVIEWS"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
        let filterItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = filterItem
        
        self.getReviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getReviews () {
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue(self.mDealerShipID, forKey: "dealership_id")
        
        servicesManager.getReviews(parameters: parmDict, completion: { (result, error) in
            DispatchQueue.main.async {
                
                
                if result.value(forKey: "reviews") is NSDictionary {
                    SVProgressHUD.dismiss()
                    self.mArrayReviews = (result.value(forKeyPath: "reviews.data") as! NSArray ).mutableCopy() as! NSMutableArray
                    self.tableReview.reloadData()
                    
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
                                        self.getReviews()
                                    }
                                }
                            })
                        }
                    }
                    
                }
                
            }
        })
    }
    
    func addComment () {
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue("", forKey: "dealership_ID")
        parmDict.setValue("", forKey: "reviewer_ID")
        parmDict.setValue("PUT", forKey: "_method")
        parmDict.setValue("Thank you for the warm words, feel free to visit us again for a cup of coffee", forKey: "reply")
        
        servicesManager.addComment(parameters: parmDict, completion: { (result, error) in
            DispatchQueue.main.async {
                
                
                if result.value(forKey: "review") is NSDictionary {
                    SVProgressHUD.dismiss()
                    print("Review Added Successfully")
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
                                        self.addComment()
                                    }
                                }
                            })
                        }
                    }
                    
                }
                
            }
        })
    }
    
    
    func filterAction(){
        let secondDetailViewController = storyboard?.instantiateViewController(withIdentifier: "ReviewFilterVC")as! ReviewFilterVC
        secondDetailViewController.delegate = self
        self.presentPopupViewController(secondDetailViewController, animationType: MJPopupViewAnimationFade)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mArrayReviews.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = ReviewCell()
        
        if let reply = (mArrayReviews.object(at: indexPath.row) as! NSDictionary).value(forKey: "reply") as? String {
            print(reply)
            
            if let isEdit = (mArrayReviews.object(at: indexPath.row) as! NSDictionary).value(forKey: "isEdit") as? String{
                
                print(isEdit)
                cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell3", for: indexPath)  as! ReviewCell
                
                cell.commentText.text = (mArrayReviews.object(at: indexPath.row) as! NSDictionary).value(forKey: "reply") as? String ?? "Hi!"
                
                cell.buttonCross.addTarget(self, action: #selector(crossAction(sender:)), for: .touchUpInside)
                cell.buttonCross.tag = indexPath.row
                
                cell.buttonSubmit.addTarget(self, action: #selector(submitAction(sender:)), for: .touchUpInside)
                cell.buttonSubmit.tag = indexPath.row

            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell2", for: indexPath)  as! ReviewCell
                
                cell.buttonEdit.addTarget(self, action: #selector(editAction(sender:)), for: .touchUpInside)
                cell.buttonEdit.tag = indexPath.row
                
                cell.labelNameReplyUser.text = ((mArrayReviews.object(at: indexPath.row) as! NSDictionary).value(forKey: "replied_by") as? NSDictionary)?.value(forKey: "name") as? String ?? "Micheal"
                cell.labelDateReply.text = ((mArrayReviews.object(at: indexPath.row) as! NSDictionary).value(forKey: "replied_by") as? NSDictionary)?.value(forKey: "created_at") as? String ?? "28 feb"
                cell.labelContentReply.text = (mArrayReviews.object(at: indexPath.row) as! NSDictionary).value(forKey: "reply") as? String ?? "Hi!"

            }
            
            
          
            
            

            
        }else{
            
            if let isEdit = (mArrayReviews.object(at: indexPath.row) as! NSDictionary).value(forKey: "isEdit") as? String{
                
                print(isEdit)
                cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell3", for: indexPath)  as! ReviewCell
                
                cell.commentText.text = ""
                
                cell.buttonCross.addTarget(self, action: #selector(crossAction(sender:)), for: .touchUpInside)
                cell.buttonCross.tag = indexPath.row
                
                cell.buttonSubmit.addTarget(self, action: #selector(submitAction(sender:)), for: .touchUpInside)
                cell.buttonSubmit.tag = indexPath.row
                
            }else{
              print("Reply not found")
             cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)  as! ReviewCell
                
                cell.buttonReply.addTarget(self, action: #selector(replyAction(sender:)), for: .touchUpInside)
                cell.buttonReply.tag = indexPath.row
            }
        }
        
       
        
        
        cell.labelUser.text = (mArrayReviews.object(at: indexPath.row) as! NSDictionary).value(forKey: "replied_by") as? String ?? "Micheal"
        cell.labelDate.text = (mArrayReviews.object(at: indexPath.row) as! NSDictionary).value(forKey: "created_at") as? String ?? ""
        cell.labelContent.text = (mArrayReviews.object(at: indexPath.row) as! NSDictionary).value(forKey: "content") as? String ?? "Hi!"

        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondDetailViewController = storyboard?.instantiateViewController(withIdentifier: "ReviewsReplyVC")as! ReviewsReplyVC
        self.navigationController?.pushViewController(secondDetailViewController, animated: true)
    }
    
    
    
    func replyAction(sender:UIButton!) {
        let indexPath   = IndexPath(row: sender.tag, section: 0)
        
        let mTempDeict      = NSMutableDictionary(dictionary: self.mArrayReviews.object(at: indexPath.row) as! NSDictionary)
        mTempDeict.setValue( "Yes" , forKey: "isEdit")
        self.mArrayReviews.replaceObject(at: indexPath.row, with: mTempDeict)
        //self.tableReview.reloadData()
        
        
        tableReview.beginUpdates()
        tableReview.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        tableReview.endUpdates()
        
    }

    
    func editAction(sender:UIButton!) {
        let indexPath   = IndexPath(row: sender.tag, section: 0)
        
        let mTempDeict      = NSMutableDictionary(dictionary: self.mArrayReviews.object(at: indexPath.row) as! NSDictionary)
        mTempDeict.setValue( "Yes" , forKey: "isEdit")
        self.mArrayReviews.replaceObject(at: indexPath.row, with: mTempDeict)
        //self.tableReview.reloadData()
        
        
        tableReview.beginUpdates()
        tableReview.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        tableReview.endUpdates()
        
    }
    func crossAction(sender:UIButton!) {
        
        let indexPath   = IndexPath(row: sender.tag, section: 0)
        
        let mTempDeict      = NSMutableDictionary(dictionary: self.mArrayReviews.object(at: indexPath.row) as! NSMutableDictionary)
         mTempDeict.setValue( nil , forKey: "isEdit")
         mTempDeict.removeObject(forKey: "isEdit")
        
        self.mArrayReviews.replaceObject(at: indexPath.row, with: mTempDeict)
        //self.tableReview.reloadData()
        
        
        tableReview.beginUpdates()
        tableReview.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        tableReview.endUpdates()
        
    }
    func submitAction(sender:UIButton!) {
        
        
        let indexPath   = IndexPath(row: sender.tag, section: 0)
        let cell        = tableReview.cellForRow(at: indexPath as IndexPath) as! ReviewCell
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue((self.mArrayReviews.object(at: sender.tag) as! NSDictionary).value(forKey: "dealer_id"), forKey: "dealership_ID")
        parmDict.setValue((self.mArrayReviews.object(at: sender.tag) as! NSDictionary).value(forKey: "id"), forKey: "reviewer_ID")
        parmDict.setValue("PUT", forKey: "_method")
        parmDict.setValue(cell.commentText.text, forKey: "reply")
        
        print(parmDict)
        
        servicesManager.addComment(parameters: parmDict, completion: { (result, error) in
            DispatchQueue.main.async {
                
                
                if result.value(forKey: "review") is NSDictionary {
                    SVProgressHUD.dismiss()
                    
                    
                    
                    let indexPath   = IndexPath(row: sender.tag, section: 0)
                    
                    let mTempDeict      = result.value(forKey: "review")as! NSDictionary
                    
                    self.mArrayReviews.replaceObject(at: indexPath.row, with: mTempDeict)
                    
                    
                    self.tableReview.beginUpdates()
                    self.tableReview.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    self.tableReview.endUpdates()

                    
                    
                    print("Review Added Successfully")
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
                                        self.submitAction(sender: sender)
                                    }
                                }
                            })
                        }
                    }
                    
                }
                
            }
        })

        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ReviewFilterVC.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/9/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit


 protocol MJSecondPopupDelegate : NSObjectProtocol
{
    func cancelButtonClicked(_ secondDetailViewController: ReviewFilterVC)
    func passFilterArray(_ filterArr : NSMutableArray,_ secondDetailViewController: ReviewFilterVC)
}

var sectionArr :NSMutableArray  = []
var sortArr :NSMutableArray  = []
var typeArr :NSMutableArray  = []
var ratingArr :NSMutableArray  = []
var filterArray:NSMutableArray = []
var sortFilterArray:NSMutableArray = []
var typeFilterArray:NSMutableArray = []

class ReviewFilterVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var backGroundImage: UIImageView!
    
    @IBOutlet var tableFilter: UITableView!

    public var delegate: MJSecondPopupDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        sectionArr  = ["SORT","TYPE","RATING"]
        sortArr     = ["Most resent reviews first","Oldest reviews first","Higest ratings first","Lowest ratings first"]
        typeArr     = ["All reviews","Reviews with replys","Reviews without replys"]
        ratingArr   = ["1 star","2 star","3 star","4 star","5 star"]
        
        
        //add values for shorting
        
        sortFilterArray = ["sort=created_at&order=DESC","sort=created_at&order=ASC","sort=rating&order=DESC","sort=rating&order=ASC"]
        typeFilterArray = ["","replies_filter=with_replies","replies_filter=no_replies"]
        // Do any additional setup after loading the view.
        
   
        
        let tapRecognizerLeft = UITapGestureRecognizer(target: self, action: #selector(ReviewFilterVC.handleTap))
        backGroundImage.addGestureRecognizer(tapRecognizerLeft)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewFilterVC.handleTapTable))
        tableFilter.addGestureRecognizer(tapRecognizer)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.delegate?.cancelButtonClicked(self)
    }

    func handleTapTable(sender: UITapGestureRecognizer? = nil) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionArr.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return sortArr.count
        }else if section == 1{
            return typeArr.count
        }else if section == 2{
            return ratingArr.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ReviewFilterCell()
        
        
        
        if indexPath.section == 0{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ReviewFilterCell", for: indexPath)  as! ReviewFilterCell
            cell.labelType.text = sortArr.object(at: indexPath.row) as? String
            cell.buttonRadio.addTarget(self, action: #selector(radioButtonAction(sender: )), for: .touchUpInside)
            
            
            cell.buttonRadio.isSelected = false
            
            if filterArray.count>0
            {
                if filterArray.contains("sort=created_at&order=DESC") && indexPath.row == 0/*filterArray.object(at: indexPath.row)as? String == "sort=created_at&order=DESC" */{
                    cell.buttonRadio.isSelected = true
                }else if filterArray.contains("sort=created_at&order=ASC") && indexPath.row == 1/*filterArray.object(at: indexPath.row) as? String == "sort=created_at&order=ASC" */{
                    cell.buttonRadio.isSelected = true
                }else if filterArray.contains("sort=rating&order=DESC") && indexPath.row == 2/*filterArray.object(at: indexPath.row) as? String == "sort=rating&order=DESC"*/ {
                    cell.buttonRadio.isSelected = true
                }else if filterArray.contains("sort=rating&order=ASC") && indexPath.row == 3/*filterArray.object(at: indexPath.row) as? String == "sort=rating&order=ASC"*/ {
                    cell.buttonRadio.isSelected = true
                }
            }
            
            
           
            
            
            
            
            
        }else if indexPath.section == 1{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ReviewFilterCell", for: indexPath)  as! ReviewFilterCell
            cell.labelType.text = typeArr.object(at: indexPath.row) as? String
            cell.buttonRadio.addTarget(self, action: #selector(radioButtonAction(sender: )), for: .touchUpInside)
            
            
            cell.buttonRadio.isSelected = false
            
            
            if filterArray.count>0
            {
                if filterArray.contains("") && indexPath.row == 0/*filterArray.object(at: indexPath.row) as? String == ""*/{
                    cell.buttonRadio.isSelected = true
                }else if filterArray.contains("replies_filter=with_replies") && indexPath.row == 1/*filterArray.object(at: indexPath.row) as? String == "replies_filter=with_replies"*/ {
                    cell.buttonRadio.isSelected = true
                }else if filterArray.contains("replies_filter=no_replies") && indexPath.row == 2/*filterArray.object(at: indexPath.row) as? String == "replies_filter=no_replies"*/ {
                    cell.buttonRadio.isSelected = true
                }

            }
            
            
            
        }else if indexPath.section == 2{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ReviewFilterCellStar", for: indexPath)  as! ReviewFilterCell
            cell.labelStar.text = ratingArr.object(at: indexPath.row) as? String
            
            cell.buttonBox.addTarget(self, action: #selector(boxButtonAction(sender: )), for: .touchUpInside)
            
            
            
            
            
            if indexPath.row == 0{
                cell.star2.isHidden = true
                cell.star3.isHidden = true
                cell.star4.isHidden = true
                cell.star5.isHidden = true
            }else if indexPath.row == 1{
                cell.star2.isHidden = false
                cell.star3.isHidden = true
                cell.star4.isHidden = true
                cell.star5.isHidden = true
            }else if indexPath.row == 2{
                cell.star2.isHidden = false
                cell.star3.isHidden = false
                cell.star4.isHidden = true
                cell.star5.isHidden = true
            }else if indexPath.row == 3{
                cell.star2.isHidden = false
                cell.star3.isHidden = false
                cell.star4.isHidden = false
                cell.star5.isHidden = true
            }else if indexPath.row == 4{
                cell.star2.isHidden = false
                cell.star3.isHidden = false
                cell.star4.isHidden = false
                cell.star5.isHidden = false
            }
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArr.object(at: section) as? String
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.cancelButtonClicked(self)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        
        let header: UITableViewHeaderFooterView? = (view as? UITableViewHeaderFooterView)
        header?.textLabel?.textColor = UIColor.gray
        
        header?.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
        
      
        
        
    }
    
    func radioButtonAction(sender:UIButton){
        
        let point = tableFilter.convert(CGPoint.zero, from: sender)
        if let indexPath = tableFilter.indexPathForRow(at: point) {
            // Do something with indexPath
            let section = indexPath.section
            let row = indexPath.row
            
            var selectValue = String()
            if section == 0{
                
                filterArray.remove("sort=created_at&order=DESC")
                filterArray.remove("sort=created_at&order=ASC")
                filterArray.remove("sort=rating&order=DESC")
                filterArray.remove("sort=rating&order=ASC")
                
                if sender.isSelected == true{
                    
                }else{
                   
                    selectValue = sortFilterArray.object(at: row) as! String
                }
                
                
            }else if section == 1{
                
                
                filterArray.remove("")
                filterArray.remove("replies_filter=with_replies")
                filterArray.remove("replies_filter=no_replies")
                
                if sender.isSelected == true{
                    //filterArray.remove(sortFilterArray.object(at: row))
                }else{
                    selectValue = typeFilterArray.object(at: row) as! String
                }
            }
            filterArray.add(selectValue)
            tableFilter.reloadData()
            print(section,row)
        }
    }
    func boxButtonAction(sender:UIButton){
        let point = tableFilter.convert(CGPoint.zero, from: sender)
        if let indexPath = tableFilter.indexPathForRow(at: point) {
            // Do something with indexPath
            let section = indexPath.section
            let row = indexPath.row
             print(section,row)
        }
    }

    
    @IBAction func dismissPopView(_ sender: AnyObject) {
        
           // self.delegate?.cancelButtonClicked(self)
        }

    @IBAction func applyAction(_ sender: AnyObject) {
        
        self.delegate?.passFilterArray(filterArray, self)
        //self.delegate?.cancelButtonClicked(self)
    }
    

}

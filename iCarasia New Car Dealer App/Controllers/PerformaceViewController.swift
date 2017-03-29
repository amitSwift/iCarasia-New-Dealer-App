//
//  PerformaceViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/2/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class PerformaceViewController: UIViewController   , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var mTablePerformance       : UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title                  = "Performace"
        self.navigationItem.title   = "PERFORMANCE"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:PerformanceCell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! PerformanceCell
        
        cell.mButtonReview.badgeString       = "6"
        cell.mButtonReview.badgeTextColor    = UIColor.white
        cell.mButtonReview.badgeEdgeInsets   = UIEdgeInsetsMake(21, 2, 0, 15)
        
        cell.mButtonStats.addTarget(self, action: #selector(statsAction(_:)), for: .touchUpInside)
        cell.mButtonReview.addTarget(self, action: #selector(reviewsAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func statsAction (_ sender : UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChartVC") as! ChartVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func reviewsAction (_ sender : UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
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

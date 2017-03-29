//
//  MainTabBarController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 2/23/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        // Add Common Tabs For Dealer/Sales Agents //
        self.tabBar.items?[0].title = "Performance"
        self.tabBar.items?[1].title = "Messages"
        self.tabBar.items?[2].title = "Offers"
        
        self.tabBar.items?[0].image = UIImage(named: "performance")
        self.tabBar.items?[1].image = UIImage(named: "message")
        self.tabBar.items?[2].image = UIImage(named: "offers")
        
        self.tabBar.items?[0].selectedImage = UIImage(named: "performance_Selected")
        self.tabBar.items?[1].selectedImage = UIImage(named: "message_Selected")
        self.tabBar.items?[2].selectedImage = UIImage(named: "offers_Selected")
        
        
        // Add Additional Tabs For Dealer //
        
        let userStatus          = UserDefaults()
        let userType            = userStatus.value(forKey: "current_User_Type") as! String
        
        if userType == "sales_agent"{
            
            self.tabBar.items?[3].title = "Profile"
            self.tabBar.items?[3].image = UIImage(named: "account")
            self.tabBar.items?[3].selectedImage = UIImage(named: "account_Selected")
        }
        else{
        
            self.tabBar.items?[3].title = "Agents"
            self.tabBar.items?[4].title = "Profile"
        
            self.tabBar.items?[3].image = UIImage(named: "agents")
            self.tabBar.items?[4].image = UIImage(named: "account")
        
      
            self.tabBar.items?[3].selectedImage = UIImage(named: "agents_Selected")
            self.tabBar.items?[4].selectedImage = UIImage(named: "account_Selected")
        }

        
        // Add Additional Tabs For Dealer/Sales Agents //
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

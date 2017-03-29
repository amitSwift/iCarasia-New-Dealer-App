//
//  ChartVC.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class ChartVC: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var mTableStats: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "PERFORMANCE"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell")! as! ChartCell

        cell.configUI(indexPath, and: [])
        return cell
    }

    
    

   
}

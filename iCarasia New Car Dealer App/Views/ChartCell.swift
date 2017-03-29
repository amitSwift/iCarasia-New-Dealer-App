//
//  ChartCell.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class ChartCell: UITableViewCell , UUChartDataSource {

    
    var chartView: UUChart?
    var finalArr = [Any]()
    var returnXlabelArr = [Any]()
    var path = NSIndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configUI(_ indexPath: IndexPath, and array: [Any]) {
        finalArr = [Any]()
        returnXlabelArr = [Any]()
        finalArr = [Any]()
        
//        for i in 0..<5 {
//            finalArr.append(i)
//        }
        finalArr = [1,15,12,20,18,4]
        returnXlabelArr = ["12/2","13/2","14/2","15/2","16/2","Today"]

        if (chartView != nil) {
            chartView?.removeFromSuperview()
            chartView = nil
        }
        
        path = indexPath as NSIndexPath
        
        chartView = UUChart.init()
        chartView = chartView?.initwithUUChartDataFrame(CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height), with: self, with: UUChartLineStyle) as! UUChart?
        
        //chartView = UUChart.init().initwithUUChartDataFrame(CGRect.init(x: 0, y: 0, width: 230, height: 150), with: self, with: UUChartLineStyle) as! UUChart?
        
        chartView?.show(in: self.contentView)
    }
    
    func uuChart_xLableArray(_ chart: UUChart) -> [Any] {
//        for i in 0..<finalArr.count {
//            let str: String = "\(i)"
//            returnXlabelArr.append(str)
//        }
        return [returnXlabelArr]
        // return @[@"1",@"2"];
    }
    //数值多重数组
    
    func uuChart_yValueArray(_ chart: UUChart) -> [Any] {
        
        return [finalArr]
    }
    
    // MARK: - @optional
    //颜色数组
    
    func uuChart_ColorArray(_ chart: UUChart) -> [Any] {
        return [UIColor.init(colorLiteralRed: 102/255.0, green: 171/255.0, blue: 242/255.0, alpha: 1.0)]
    }
    //显示数值范围
    
    func uuChartChooseRange(inLineChart chart: UUChart) -> CGRange {
       if path.row == 0 {
            //return CGRangeMake(60, 10)
         return CGRangeMake(25, 0)
        }
        if path.row == 2 {
           // return CGRangeMake(100, 0)
            return CGRangeMake(25, 0)
        }
        return CGRangeZero
    }
    
    // MARK: 折线图专享功能
    //标记数值区域
    
    func uuChartMarkRange(inLineChart chart: UUChart) -> CGRange {
        if path.row == 2 {
            return CGRangeMake(25, 75)
            
        }
        return CGRangeZero
    }
    //判断显示横线条
    
    func uuChart(_ chart: UUChart, showHorizonLineAt index: Int) -> Bool {
        return true
    }
    //判断显示最大最小值
    
    func uuChart(_ chart: UUChart, showMaxMinAt index: Int) -> Bool {
        //return path.row == 2
        return path.row == index
    }

}

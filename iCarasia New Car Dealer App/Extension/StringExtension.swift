//
//  StringExtension.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/31/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import Foundation


extension String{
    
    func languageSelectedStringForKey(key: String) -> String {
        
        let language = Bundle.main.preferredLocalizations.first 
        
        var path = NSString()
        if (UserDefaults.standard.value(forKey: "SelectedLanguage") as AnyObject).isEqual("id") || language == "id"{
            path = Bundle.main.path(forResource: "id", ofType: "lproj")! as NSString
        }
        else if (UserDefaults.standard.value(forKey: "SelectedLanguage") as AnyObject).isEqual("th") || language == "th"{
            path = Bundle.main.path(forResource: "th", ofType: "lproj")! as NSString
        }
        else {
            path = Bundle.main.path(forResource: "en", ofType: "lproj")! as NSString
        }
        
        let languageBundle: Bundle =  Bundle(path: path as String)!
        let str: String = languageBundle.localizedString(forKey: key, value: "", table: nil)
        return str
    }
    
}

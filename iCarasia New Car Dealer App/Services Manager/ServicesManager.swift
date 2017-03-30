//
//  ServicesManager.swift
//  looped
//
//  Created by Raman Kant on 12/19/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit
import DigitsKit

class ServicesManager: NSObject {
    
    //MARK: - BASE URL -
    let BASE_URL                            = "http://newcar.icarlabs.com/"
    var taskCompaniesList : URLSessionDataTask!
    
    //MARK: - Register -
    
    func registerUser(userCredentials: NSMutableDictionary, completion: @escaping (_ result: AnyObject , _ error : NSError? ) -> Void) {
        
        var parameters: String                      = ""
        for (key, value) in userCredentials{
            if(parameters.isEmpty){ parameters      = parameters+"\(key)"+"=\(value)" }
            else{ parameters                        = parameters+"&\(key)"+"=\(value)" }
        }
        parameters                          = parameters.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        parameters                          = parameters.replacingOccurrences(of: "+", with: "%2B")
        
        let urlString: String               = BASE_URL + "api/register"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "POST"
        
        
        let digits                              = Digits.sharedInstance()
        let oauthSigning :  DGTOAuthSigning     = DGTOAuthSigning(authConfig:digits.authConfig, authSession:digits.session())
        let authHeaders                         = oauthSigning.oAuthEchoHeadersToVerifyCredentials() as NSDictionary
        print((authHeaders.value(forKey: "X-Auth-Service-Provider"))!)
        print((authHeaders.value(forKey: "X-Verify-Credentials-Authorization"))!)
        
        request.addValue((authHeaders.value(forKey: "X-Auth-Service-Provider"))! as! String, forHTTPHeaderField: "apiUrl")
        request.addValue((authHeaders.value(forKey: "X-Verify-Credentials-Authorization"))! as! String, forHTTPHeaderField: "authHeader")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.setValue("\(UInt(parameters.lengthOfBytes(using: String.Encoding.utf8)))", forHTTPHeaderField: "Content-Length")
        
        request.httpBody            = parameters.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.timeoutInterval     = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                if error?._code == -1009 {
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Autheticate -
    
    func autheticateUser(parameters : NSMutableDictionary!, completion: @escaping (_ result: AnyObject , _ error : NSError? ) -> Void){
        
        let urlString: String               = BASE_URL + "api/authenticate"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "GET"
        
        
        let digits                              = Digits.sharedInstance()
        let oauthSigning :  DGTOAuthSigning     = DGTOAuthSigning(authConfig:digits.authConfig, authSession:digits.session())
        let authHeaders                         = oauthSigning.oAuthEchoHeadersToVerifyCredentials() as NSDictionary
        print((authHeaders.value(forKey: "X-Auth-Service-Provider"))!)
        print((authHeaders.value(forKey: "X-Verify-Credentials-Authorization"))!)
        
        request.addValue((authHeaders.value(forKey: "X-Auth-Service-Provider"))! as! String, forHTTPHeaderField: "apiUrl")
        request.addValue((authHeaders.value(forKey: "X-Verify-Credentials-Authorization"))! as! String, forHTTPHeaderField: "authHeader")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            
            DispatchQueue.main.async {
                
                if error?._code == -1009 {
                    SVProgressHUD.dismiss()
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Dealerships List -
    
    func dealershipsList(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        let urlString: String               = BASE_URL + "/dealer-api/dealership"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "GET"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if error?._code == -1009 {
                    
                    SVProgressHUD.dismiss()
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Fetch Token -
    
    func token () -> String {
        let token = UserDefaults()
        print("Token = \(token.value(forKey: "iCar_Token") as! String)")
        return token.value(forKey: "iCar_Token") as! String
    }
    
    //MARK: - Delete Dealership -
    
    func deleteDealerships(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        
        let dealer_ID                       = parameters.value(forKey: "dealer_id")
        let sales_Agent_ID                  = parameters.value(forKey: "sales_Agent_id")
        
        
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(dealer_ID!)/sales-agent/\(sales_Agent_ID!)"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "DELETE"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                if error?._code == -1009 {
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Delete Agent -
    
    func deleteAgent(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        
        let dealer_ID                       = parameters.value(forKey: "dealer_id")
        let sales_Agent_ID                  = parameters.value(forKey: "sales_Agent_id")
        
        
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(dealer_ID!)/sales-agents/\(sales_Agent_ID!)"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "DELETE"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                if error?._code == -1009 {
                    
                    SVProgressHUD.dismiss()
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    
                    return
                }
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
        task.resume()
        return
    }

    //MARK: - Models -
    
    func models(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        
        let dealership_ID                   = parameters.value(forKey: "dealership_id")
        
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(dealership_ID!)/models"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "GET"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                
                if error?._code == -1009 {
                    
                    SVProgressHUD.dismiss()
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Variant By ID -
    
    func variantsByID(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        
        let varients_ID                     = parameters.value(forKey: "varient_id")
        let urlString: String               = BASE_URL + "vehicle-api/variant/\(varients_ID!)"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "GET"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                if error?._code == -1009 {
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Variants List -
    
    func variants(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        
        let delaership_ID                   = parameters.value(forKey: "delaership_id")
        let model_ID                        = parameters.value(forKey: "model_id")
        
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(delaership_ID!)/models/\(model_ID!)/vehicles"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "GET"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if error?._code == -1009 {
                    
                    SVProgressHUD.dismiss()
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Dealership Profile -
    
    func dealershipProfile(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        let dealer_ID                       = parameters.value(forKey: "dealer_id")
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(dealer_ID!)/profile"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "GET"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                if error?._code == -1009 {
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Sales Agent Profile -
    
    func salesAgentProfile(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        let urlString: String               = BASE_URL + "api/profile"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "GET"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                if error?._code == -1009 {
                    SVProgressHUD.dismiss()

                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()

                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Agents List -
    
    func salesAgentsList(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        let dealership_ID                   = parameters.value(forKey: "dealership_ID")
        
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(dealership_ID!)/sales-agents"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "GET"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                if error?._code == -1009 {
                    SVProgressHUD.dismiss()
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Add Agent -
    
    func addAgent(parameters : NSMutableDictionary!, completion: @escaping ( _ result: NSDictionary , _ error : NSError? ) -> Void){
        
        let dealership_ID                   = parameters.value(forKey: "dealership_ID")
        
        var parametersString: String                            = ""
        for (key, value) in parameters{
            if(parametersString.isEmpty){ parametersString      = parametersString+"\(key)"+"=\(value)" }
            else{
                parametersString                                = parametersString+"&\(key)"+"=\(value)" }
        }
        parametersString                    = parametersString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        parametersString                    = parametersString.replacingOccurrences(of: "+", with: "%2B")
        
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(dealership_ID!)/sales-agents"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "POST"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.setValue("\(UInt(parametersString.lengthOfBytes(using: String.Encoding.utf8)))", forHTTPHeaderField: "Content-Length")
        request.httpBody                    = parametersString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                if error?._code == -1009 {
                    SVProgressHUD.dismiss()
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Get Offer -
    
    func getOffer(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        let dealership_ID                   = parameters.value(forKey: "dealership_ID")
        let model_ID                        = parameters.value(forKey: "model_ID")
        let vehicle_ID                      = parameters.value(forKey: "vehicle_ID")
        
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(dealership_ID!)/models/\(model_ID!)/vehicles/\(vehicle_ID!)/offers"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "GET"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                if error?._code == -1009 {
                    SVProgressHUD.dismiss()
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Add Offer -
    
    func addOffer(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        let dealership_ID                   = parameters.value(forKey: "dealership_ID")
        let model_ID                        = parameters.value(forKey: "model_ID")
        let vehicle_ID                      = parameters.value(forKey: "vehicle_ID")

        
        var parametersString: String                            = ""
        for (key, value) in parameters{
            if(parametersString.isEmpty){ parametersString      = parametersString+"\(key)"+"=\(value)" }
            else{
                parametersString                                = parametersString+"&\(key)"+"=\(value)" }
        }
        parametersString                          = parametersString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(dealership_ID!)/models/\(model_ID!)/vehicles/\(vehicle_ID!)/offers"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "POST"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.setValue("\(UInt(parametersString.lengthOfBytes(using: String.Encoding.utf8)))", forHTTPHeaderField: "Content-Length")
        request.httpBody                    = parametersString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                if error?._code == -1009 {
                    SVProgressHUD.dismiss()
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Add Offer -
    
    func getReviews(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        let dealership_ID                   = parameters.value(forKey: "dealership_ID")
        let urlString: String               = BASE_URL + "dealer-api/dealership/3/reviews"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "GET"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                if error?._code == -1009 {
                    SVProgressHUD.dismiss()
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Add Comment To Reviews -
    
    func addComment(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        let dealership_ID       = parameters.value(forKey: "dealership_ID")
        let reviewer_ID        = parameters.value(forKey: "reviewer_ID")
        
        var parametersString: String                            = ""
         for (key, value) in parameters{
         if(parametersString.isEmpty){ parametersString      = parametersString+"\(key)"+"=\(value)" }
         else{
         parametersString                                = parametersString+"&\(key)"+"=\(value)" }
         }
         parametersString                          = parametersString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(dealership_ID!)/reviews/\(reviewer_ID!)"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "POST"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        //request.setValue("\(UInt(parametersString.lengthOfBytes(using: String.Encoding.utf8)))", forHTTPHeaderField: "Content-Length")
        //request.httpBody                    = parametersString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                if error?._code == -1009 {
                    SVProgressHUD.dismiss()
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
        task.resume()
        return
    }
    
    //MARK: - Change Manager -
    
    func changeManager(parameters : NSMutableDictionary!, completion: @escaping (_ result: NSDictionary , _ error : NSError? ) -> Void){
        
        let dealer_ID       = parameters.value(forKey: "dealer_ID")
        let agent_ID        = parameters.value(forKey: "agent_ID")
        
        /*var parametersString: String                            = ""
        for (key, value) in parameters{
            if(parametersString.isEmpty){ parametersString      = parametersString+"\(key)"+"=\(value)" }
            else{
                parametersString                                = parametersString+"&\(key)"+"=\(value)" }
        }
        parametersString                          = parametersString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!*/
        
        
        let urlString: String               = BASE_URL + "dealer-api/dealership/\(dealer_ID!)/sales-agents/\(agent_ID!)/make-branch-manager"
        let urlWithPercentEscapes           = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request: NSMutableURLRequest    = NSMutableURLRequest(url: NSURL(string: urlWithPercentEscapes!)! as URL)
        request.httpMethod                  = "POST"
        
        request.addValue("Bearer : \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        //request.setValue("\(UInt(parametersString.lengthOfBytes(using: String.Encoding.utf8)))", forHTTPHeaderField: "Content-Length")
        //request.httpBody                    = parametersString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.timeoutInterval             = 90.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                if error?._code == -1009 {
                    SVProgressHUD.dismiss()
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    TSMessage.showNotification(in: delegate.window?.rootViewController, title: "\nNo internet connection!", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary {
                        print(jsonDict)
                        completion(jsonDict , error as NSError?)
                    }
                } catch let error as NSError {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
        task.resume()
        return
    }

}

// MARK: - Extension for image Uploading -

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}





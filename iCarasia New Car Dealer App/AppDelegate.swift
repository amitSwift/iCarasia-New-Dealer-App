
//
//  AppDelegate.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 2/22/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import DigitsKit
import CoreTelephony
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var frameWidth = CGFloat()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Digits.self])
        
        application.applicationIconBadgeNumber = 0
        
        frameWidth = (self.window?.frame.size.width)!;
        UserDefaults.standard.set(frameWidth, forKey: "frameWidth");
        
        let alApplocalNotificationHnadler : ALAppLocalNotifications =  ALAppLocalNotifications.appLocalNotificationHandler();
        alApplocalNotificationHnadler.dataConnectionNotificationHandler();
        if (launchOptions != nil){
            //let dictionary = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary
            let dictionary = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
            if (dictionary != nil){
                print("launched from push notification")
                let alPushNotificationService: ALPushNotificationService = ALPushNotificationService()
                
                let appState: NSNumber = NSNumber(value: 0 as Int32)
                let applozicProcessed = alPushNotificationService.processPushNotification(launchOptions,updateUI:appState)
                if (!applozicProcessed){
                }
            }
        }
        
        //Enable APNS Notifications //
        if #available(iOS 10.0, *) {
            let center      = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error    == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            
            let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
            
        }
        
        self.enableIQKeyBoardManager()
        let loginStatus = UserDefaults()
        if (loginStatus.bool(forKey: "loginStatus") == true){
            self.updateRootController(loginStatus: true)
        }
        //NotificationCenter.default.addObserver(self, selector: #selector(logOut), name: NSNotification.Name(rawValue: "logut_Notification"), object: nil)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.darkGray], for: .normal)
        self.window?.backgroundColor = UIColor.init(colorLiteralRed: 0/255.0, green: 180/255.0, blue: 240/255.0, alpha: 1.0)
        
        /*
        let info                = CTTelephonyNetworkInfo()
        let carrier: CTCarrier? = info.subscriberCellularProvider
        print("Country code is: \(carrier?.mobileCountryCode)")
        Swift.debugPrint("Country code is: \(carrier?.mobileCountryCode)")*/
        
        return true
    }
    
    func logOut(){
        
        
        let loginStatus = UserDefaults()
        loginStatus.set(false, forKey: "loginStatus")
        UserDefaults().synchronize()
        
        let registerUserClientService: ALRegisterUserClientService = ALRegisterUserClientService()
        registerUserClientService.logout(completionHandler: {
        })
        Digits.sharedInstance().logOut()
        self.updateRootController(loginStatus: false)
        
    }
    
    func updateRootController( loginStatus : Bool) {
        
        if loginStatus == true {
            
            
            let storyBoardApplozic  = UIStoryboard(name: "Applozic", bundle: nil)
            //let contactsVC        = storyBoard.instantiateViewController(withIdentifier: "ALNewContactsViewController")
            //let contactsNC        = UINavigationController(rootViewController: contactsVC)
            
            let chatVC              = storyBoardApplozic.instantiateViewController(withIdentifier: "ALViewController")
            let chatNC              = UINavigationController(rootViewController: chatVC)
            self.navigationBarAppearence(navigationController: chatNC)
            
            //let profileVC           = storyBoardApplozic.instantiateViewController(withIdentifier: "ALUserProfileView")
            //let profileNC           = UINavigationController(rootViewController: profileVC)
            
            let storyBoard          = UIStoryboard(name: "Main", bundle: nil)
            
            let performaceVC        = storyBoard.instantiateViewController(withIdentifier: "PerformaceViewController") as! PerformaceViewController
            let performaceNC        = UINavigationController(rootViewController: performaceVC)
            self.navigationBarAppearence(navigationController: performaceNC)
            
            let offersVC            = storyBoard.instantiateViewController(withIdentifier: "OffersViewController") as! OffersViewController
            let offersNC            = UINavigationController(rootViewController: offersVC)
            self.navigationBarAppearence(navigationController: offersNC)
            
            //let agentsVC            = storyBoard.instantiateViewController(withIdentifier: "AgentsViewController") as! AgentsViewController
            //let agentsNC            = UINavigationController(rootViewController: agentsVC)
            //self.navigationBarAppearence(navigationController: agentsNC)
            
            let agentsDShipsVC            = storyBoard.instantiateViewController(withIdentifier: "AgentsDealershipsViewController") as! AgentsDealershipsViewController
            let agentsDShipsNC            = UINavigationController(rootViewController: agentsDShipsVC)
            self.navigationBarAppearence(navigationController: agentsDShipsNC)
            
            let profileVC           = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            let profileNC           = UINavigationController(rootViewController: profileVC)
            self.navigationBarAppearence(navigationController: profileNC)
            
            let tabBar              = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
            
            
            let userStatus          = UserDefaults()
            let userType            = userStatus.value(forKey: "current_User_Type") as! String
            
            if userType == "sales_agent"{
                tabBar.viewControllers  = [performaceNC , chatNC , offersNC , profileNC]

            }else{
                tabBar.viewControllers  = [performaceNC , chatNC , offersNC , agentsDShipsNC , profileNC]
            }
            self.window?.rootViewController = tabBar
            self.disableIQKeyBoardManager()

        }
        else {
            let storyBoard              = UIStoryboard(name: "Main", bundle: nil)
            let mainNC                  = storyBoard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
            self.window?.rootViewController = mainNC
            self.enableIQKeyBoardManager()
            
        }
    }
    
    func navigationBarAppearence ( navigationController : UINavigationController) {
        
        navigationController.navigationBar.isTranslucent      = false
        navigationController.navigationBar.barTintColor       = UIColor.init(colorLiteralRed: 0/255.0, green: 180/255.0, blue: 240/255.0, alpha: 1.0)
        navigationController.navigationBar.barStyle           = .black
        navigationController.navigationBar.tintColor          = UIColor.white
        
        
        let backImage = UIImage(named: "back")
        navigationController.navigationBar.backIndicatorImage                 = backImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage   = backImage
        navigationController.navigationBar.backItem?.title                    = ""

    }
    
    func enableIQKeyBoardManager() {
        
        IQKeyboardManager.shared().isEnabled                        = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside       = true
        IQKeyboardManager.shared().isEnableAutoToolbar              = true
        IQKeyboardManager.shared().keyboardDistanceFromTextField    = 50
    }
    
    func disableIQKeyBoardManager() {
        
        IQKeyboardManager.shared().isEnabled                        = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside       = false
        IQKeyboardManager.shared().isEnableAutoToolbar              = false
        IQKeyboardManager.shared().keyboardDistanceFromTextField    = 50
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Token : \(deviceTokenString)")
        UserDefaults.standard.set(deviceTokenString, forKey: "device_token")
        UserDefaults.standard.synchronize()
        
        if (ALUserDefaultsHandler.getApnDeviceToken() != deviceTokenString){
            let alRegisterUserClientService: ALRegisterUserClientService = ALRegisterUserClientService()
                print(alRegisterUserClientService)
            }
        }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("I am not available in simulator \(error)")
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let dicInfo = (response.notification.request.content.userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary
        print(dicInfo)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let dicInfo = (notification.request.content.userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary
        TSMessage.showNotification(in: self.window?.rootViewController, title: dicInfo.value(forKey: "alert")as? String, subtitle: nil, type: TSMessageNotificationType.message)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "iCarasia_New_Car_Dealer_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


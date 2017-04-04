//
//  DealershipDetailsViewController.swift
//  iCarasia New Car Dealer App
//
//  Created by Raman Kant on 3/6/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

class DealershipDetailsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate,TOCropViewControllerDelegate{
    
    @IBOutlet weak var mTableDealerShipDetails       : UITableView!
    @IBOutlet weak var mViewHeader                   : UIView!
    
    @IBOutlet weak var mImageViewDealership          : UIImageView!
    @IBOutlet weak var mButtonCamera                 : UIButton!
    @IBOutlet weak var mTextFieldDealershipTitle     : UITextField!
    @IBOutlet weak var mLabelDealershipMake          : UILabel!
    @IBOutlet weak var mTextViewDealershipInfo       : UITextView!
    
    var isEditMode              = Bool()
    
    var mDealershipInfoDict     = NSDictionary()
    var mArrayDealershipInfo    = NSMutableArray()
    
    var mImageDealership        = UIImage()
    var croppingStyle           = TOCropViewCroppingStyle.default
    
    //var mImageData    = Data()
    //var mStrBase64    = String()
    
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
        
        mImageViewDealership.layer.cornerRadius = 5.0
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.enableIQKeyBoardManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.disableIQKeyBoardManager()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let frame           = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: mTextViewDealershipInfo.frame.minY)
        mViewHeader.frame   = frame
    }
    
    // MARK: - UI Setup -
    
    func setupUI () {
        
        print("Dealership Info : \(mDealershipInfoDict)")
        
        self.isEditMode                                     = false
        self.mButtonCamera.isHidden                         = true
        mTextFieldDealershipTitle.isUserInteractionEnabled  = false
        mTextViewDealershipInfo.isUserInteractionEnabled    = false
        mArrayDealershipInfo.removeAllObjects()
        
        mTextFieldDealershipTitle.text  = mDealershipInfoDict.value(forKey: "name") as! String?
        mLabelDealershipMake.text       = mDealershipInfoDict.value(forKeyPath: "make.name") as! String?
        mTextViewDealershipInfo.text    = mDealershipInfoDict.value(forKey:"short_description") as! String?
        mImageViewDealership.sd_setImage(with: URL(string:mDealershipInfoDict.value(forKey: "profile_image_large_url") as! String)  , placeholderImage: nil)
        

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
        
        if let facebook  = mDealershipInfoDict.value(forKey: "facebook") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(facebook, forKey: "facebook")
            arraySecondSection.add(tempDict)
        }
        
        if let instagram      = mDealershipInfoDict.value(forKey: "instagram") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(instagram, forKey: "instagram")
            arraySecondSection.add(tempDict)
        }
        
        if let google_plus      = mDealershipInfoDict.value(forKey: "google_plus") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(google_plus, forKey: "google_plus")
            arraySecondSection.add(tempDict)
        }
        
        if let twitter      = mDealershipInfoDict.value(forKey: "twitter") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(twitter, forKey: "twitter")
            arraySecondSection.add(tempDict)
        }
        
        if let whatsapp     = mDealershipInfoDict.value(forKey: "whatsapp") as? String {
            let tempDict    = NSMutableDictionary()
            tempDict.setValue(whatsapp, forKey: "whatsapp")
            arraySecondSection.add(tempDict)
        }
        mArrayDealershipInfo.add(arraySecondSection)
        self.mTableDealerShipDetails.reloadData()
        
    }
    
    func setupUIEditMode () {
        
        print("Dealership Info : \(mDealershipInfoDict)")
        
        
        if self.isEditMode {
            
            self.view.endEditing(true)
            
            self.mTextFieldDealershipTitle.text          = self.mTextFieldDealershipTitle.text?.trimmingCharacters(in: .whitespaces)
            self.mTextViewDealershipInfo.text            = self.mTextViewDealershipInfo.text?.trimmingCharacters(in: .whitespaces)
            
            if mTextFieldDealershipTitle.text?.characters.count == 0 {
                TSMessage.showNotification(in: self , title: "\nEnter dealership name.", subtitle: nil, type: TSMessageNotificationType.message)
                return
            }
            
            let website = (((self.mArrayDealershipInfo.object(at: 0) as! NSMutableArray).object(at: 1) as! NSMutableDictionary).value(forKey: "website")) as! String
            
            if website.characters.count > 0 {
                
                if validateWebsiteUrl(stringURL: website as NSString) == false {
                    TSMessage.showNotification(in: self , title: "\nEnter a valid website url.", subtitle: nil, type: TSMessageNotificationType.message)
                    return
                }
            }
            
            self.saveDealershipInfo()
        }else{
            
            
            let editButtonItem      = UIBarButtonItem.init(image: UIImage(named:"save"), style: .plain, target: self, action: #selector(editAction))
            self.navigationItem.rightBarButtonItems = [editButtonItem]
            
            self.isEditMode                                     = true
            self.mButtonCamera.isHidden                         = false
            mTextFieldDealershipTitle.isUserInteractionEnabled  = true
            mTextViewDealershipInfo.isUserInteractionEnabled    = true
            mArrayDealershipInfo.removeAllObjects()
            
            mTextFieldDealershipTitle.text  = mDealershipInfoDict.value(forKey: "name") as! String?
            mLabelDealershipMake.text       = mDealershipInfoDict.value(forKeyPath: "make.name") as! String?
            //mTextViewDealershipInfo.text    = ""
            
            // First Section //
            
            let arrayFirstSection = NSMutableArray()
            
            if let phoneNumber  = mDealershipInfoDict.value(forKey: "phone_number") {
                let tempDict    = NSMutableDictionary()
                tempDict.setValue(phoneNumber, forKey: "phone_number")
                arrayFirstSection.add(tempDict)
            }else{
                let tempDict    = NSMutableDictionary()
                tempDict.setValue("", forKey: "phone_number")
                arrayFirstSection.add(tempDict)
            }
            
            if let website      = mDealershipInfoDict.value(forKey: "website") {
                let tempDict    = NSMutableDictionary()
                tempDict.setValue(website, forKey: "website")
                arrayFirstSection.add(tempDict)
            }else{
                let tempDict    = NSMutableDictionary()
                tempDict.setValue("", forKey: "website")
                arrayFirstSection.add(tempDict)
            }
            
            if let address      = mDealershipInfoDict.value(forKey: "address") {
                let tempDict    = NSMutableDictionary()
                tempDict.setValue(address, forKey: "address")
                arrayFirstSection.add(tempDict)
            }else{
                let tempDict    = NSMutableDictionary()
                tempDict.setValue("", forKey: "address")
                arrayFirstSection.add(tempDict)
            }
            
            if let city      = mDealershipInfoDict.value(forKey: "city") {
                let tempDict    = NSMutableDictionary()
                tempDict.setValue(city, forKey: "city")
                arrayFirstSection.add(tempDict)
            }else{
                let tempDict    = NSMutableDictionary()
                tempDict.setValue("", forKey: "city")
                arrayFirstSection.add(tempDict)
            }
            
            if let zip      = mDealershipInfoDict.value(forKey: "zip") {
                let tempDict    = NSMutableDictionary()
                tempDict.setValue(zip, forKey: "zip")
                arrayFirstSection.add(tempDict)
            }else{
                let tempDict    = NSMutableDictionary()
                tempDict.setValue("", forKey: "zip")
                arrayFirstSection.add(tempDict)
            }
            
            mArrayDealershipInfo.add(arrayFirstSection)
            
            // Second Section //
            
            let arraySecondSection = NSMutableArray()
            
            if let facebook  = mDealershipInfoDict.value(forKey: "facebook") as? String {
                let tempDict    = NSMutableDictionary()
                tempDict.setValue(facebook, forKey: "facebook")
                arraySecondSection.add(tempDict)
            }else{
                let tempDict    = NSMutableDictionary()
                tempDict.setValue("", forKey: "facebook")
                arraySecondSection.add(tempDict)
            }
            
            if let instagram      = mDealershipInfoDict.value(forKey: "instagram") as? String {
                let tempDict    = NSMutableDictionary()
                tempDict.setValue(instagram, forKey: "instagram")
                arraySecondSection.add(tempDict)
            }else{
                let tempDict    = NSMutableDictionary()
                tempDict.setValue("", forKey: "instagram")
                arraySecondSection.add(tempDict)
            }
            
            if let google_plus      = mDealershipInfoDict.value(forKey: "google_plus") as? String {
                let tempDict    = NSMutableDictionary()
                tempDict.setValue(google_plus, forKey: "google_plus")
                arraySecondSection.add(tempDict)
            }else{
                let tempDict    = NSMutableDictionary()
                tempDict.setValue("", forKey: "google_plus")
                arraySecondSection.add(tempDict)
            }
            
            if let twitter      = mDealershipInfoDict.value(forKey: "twitter") as? String {
                let tempDict    = NSMutableDictionary()
                tempDict.setValue(twitter, forKey: "twitter")
                arraySecondSection.add(tempDict)
            }else{
                let tempDict    = NSMutableDictionary()
                tempDict.setValue("", forKey: "twitter")
                arraySecondSection.add(tempDict)
                
            }
            
            if let whatsapp      = mDealershipInfoDict.value(forKey: "whatsapp") as? String {
                let tempDict    = NSMutableDictionary()
                tempDict.setValue(whatsapp, forKey: "whatsapp")
                arraySecondSection.add(tempDict)
            }else{
                let tempDict    = NSMutableDictionary()
                tempDict.setValue("", forKey: "whatsapp")
                arraySecondSection.add(tempDict)
            }
            
            mArrayDealershipInfo.add(arraySecondSection)
            self.mTableDealerShipDetails.reloadData()
        }
        
    }
    
    //MARK: - Button Actions -
    
    
    @IBAction func addDeralerShip ( sender : UIButton ){
        
    }
    
    @IBAction func cameraAction ( sender : UIButton ) {
        
        self.view.endEditing(true)
        
        let alert           = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction    = UIAlertAction(title: "Camera", style: .default) {
            (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                
                let imagePicker                         = UIImagePickerController()
                imagePicker.navigationController?.navigationBar.barTintColor  = UIColor(red: 218.0/255.0, green: 67.0/255.0, blue: 20.0/255.0, alpha: 1.0)
                imagePicker.navigationController?.navigationBar.tintColor     = UIColor.white
                imagePicker.delegate                    = self
                imagePicker.sourceType                  = UIImagePickerControllerSourceType.camera;
                imagePicker.mediaTypes                  = [kUTTypeImage as String]
                imagePicker.allowsEditing               = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let libraryAction   = UIAlertAction(title: "Library", style: .default) {
            (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                
                let imagePicker                         = UIImagePickerController()
                imagePicker.navigationController?.navigationBar.barTintColor  = UIColor(red: 218.0/255.0, green: 67.0/255.0, blue: 20.0/255.0, alpha: 1.0)
                imagePicker.navigationController?.navigationBar.tintColor     = UIColor.white
                imagePicker.delegate                    = self
                imagePicker.sourceType                  = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.mediaTypes                  = [kUTTypeImage as String]
                imagePicker.allowsEditing               = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction    = UIAlertAction(title: "Cancel", style: .cancel) {
            (action: UIAlertAction) in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func editAction() {
        
        print("Edit Button Pressed")
        self.setupUIEditMode()
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
        var placeHolder     : String!
        var enableField     : Bool!
        var keyBoard        : UIKeyboardType!
        
        switch dictDetails.allKeys[0] as! String {
        case "phone_number":
            enableField     = false
            cellIdentifier  = "phoneCell"
            placeHolder     = "Phone Number"
            keyBoard        = .phonePad
            titleValue      = dictDetails.value(forKey: "phone_number") as! String!
            break
        case "website":
            enableField     = true
            cellIdentifier  = "websiteCell"
            placeHolder     = "Website"
            keyBoard        = .emailAddress
            titleValue      = dictDetails.value(forKey: "website") as! String!
            break
        case "address":
            enableField     = false
            placeHolder     = "Location"
            cellIdentifier  = "locationCell"
            keyBoard        = .emailAddress
            if isEditMode {
                titleValue      = dictDetails.value(forKey: "address") as! String!
            }else{
                titleValue      = dictDetails.value(forKey: "address") as! String! + ", \(self.mDealershipInfoDict.value(forKey: "zip") as! String)" + " \(self.mDealershipInfoDict.value(forKey: "city") as! String)"
            }
            
            break
            
        case "city":
            enableField     = false
            cellIdentifier  = "locationCell"
            placeHolder     = "City"
            keyBoard        = .emailAddress
            titleValue      = dictDetails.value(forKey: "city") as! String!
            break
            
        case "zip":
            enableField     = false
            cellIdentifier  = "locationCell"
            placeHolder     = "Aip Code"
            keyBoard        = .numberPad
            titleValue      = dictDetails.value(forKey: "zip") as! String!
            break
            
        default:
            break
        }
        
        cell                    = self.mTableDealerShipDetails.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let mTextField          = cell.viewWithTag(2) as! UITextField
        mTextField.placeholder  = placeHolder
        mTextField.text         = titleValue
        mTextField.keyboardType = keyBoard
        
        //isEditMode ? (mTextLabel.isUserInteractionEnabled = enableField) : (mTextLabel.isUserInteractionEnabled = false)
        
        return cell
    }
    
    func configureCellForSecondSectionWithIndexPath ( indexPath : IndexPath ) -> UITableViewCell {
        
        
        var cellIdentifier  : String!
        var cell            : UITableViewCell!
        let dictDetails     = (self.mArrayDealershipInfo.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary
        var image           : String!
        //var title           : String!
        var placeHolder     : String!
        var titleInfo       : String!
        var keyBoard        : UIKeyboardType!
        
        switch dictDetails.allKeys[0] as! String {
        case "facebook":
            image           = "facebook"
            title           = "Facebook"
            placeHolder     = "Facebook"
            keyBoard        = .emailAddress
            
            titleInfo       = dictDetails.value(forKey: "facebook") as! String
            break
        case "instagram":
            image           = "instagram"
            title           = "Instagram"
            placeHolder     = "Instagram"
            keyBoard        = .emailAddress
            
            titleInfo       = dictDetails.value(forKey: "instagram") as! String
            break
        case "google_plus":
            image           = "google-plus"
            title           = "Google +"
            placeHolder     = "Google +"
            keyBoard        = .emailAddress
            titleInfo = dictDetails.value(forKey: "google_plus") as! String
            break
        case "twitter":
            image           = "twitter"
            title           = "Twitter"
            placeHolder     = "Twitter"
            keyBoard        = .emailAddress
            titleInfo       = dictDetails.value(forKey: "twitter") as! String
            break
        case "whatsapp":
            image           = "whatsapp"
            title           = "Whatsapp"
            placeHolder     = "Whatsapp"
            keyBoard        = .phonePad
            titleInfo       = dictDetails.value(forKey: "whatsapp") as! String
            break
        default:
            break
        }
        
        cellIdentifier      = "socialCell"
        cell                = self.mTableDealerShipDetails.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        
        let imageView       = cell.viewWithTag(1) as! UIImageView
        imageView.image     = UIImage(named: image)
        
        //let mTextLabel      = cell.viewWithTag(2) as! UILabel
        //mTextLabel.text     = title
        
        let mTextFieldInfo          = cell.viewWithTag(3) as! UITextField
        mTextFieldInfo.placeholder  = placeHolder
        mTextFieldInfo.text         = titleInfo
        mTextFieldInfo.keyboardType = keyBoard
        
        isEditMode ? (mTextFieldInfo.isUserInteractionEnabled = true) : (mTextFieldInfo.isUserInteractionEnabled = false)
        
        return cell
    }
    
    
    //MARK: - ImagePickerController Delegate -
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let resizedImage                = image.resizeWith(percentage: 0.5)
            //self.mImageViewDealership.image = resizedImage
            
            //self.mImageDealership             = resizedImage!
            
            //self.mImageData                 = UIImageJPEGRepresentation(resizedImage!, 1.0)! as Data
            //self.mStrBase64                 = mImageData.base64EncodedString(options:.lineLength64Characters) as String
            
            //set cropview controller for present
            let cropController = TOCropViewController.init(croppingStyle: croppingStyle, image: resizedImage)
            cropController?.delegate = self
            
            //self.mImageViewDealership.image = resizedImage
            //If profile picture, push onto the same navigation stack
            
            self.present(cropController!, animated: true, completion: { _ in })
            
            print("Update Profile")
        }
        
        
    }
    
    
    
    //MARK: cropview delegate
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!)
    {
        self.dismiss(animated: true, completion: { () -> Void in
            if image != nil
            {
                let cropController:TOCropViewController = TOCropViewController(image: image)
                cropController.delegate=self
                self.present(cropController, animated: true, completion: nil)
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: { () -> Void in })
    }
    
    // -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
    //        Cropper Delegate
    // -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
    
    func cropViewController(_ cropViewController: TOCropViewController!, didCropTo image: UIImage!, with cropRect: CGRect, angle: Int)
    {
        //Save image to document directory //aaaa
        
        self.mImageDealership           = image!
        self.mImageViewDealership.image = image
        
        dismiss(animated: true, completion: nil)
        //_ = navigationController?.popViewController(animated: true)
        
        cropViewController.dismiss(animated: true) { () -> Void in
            // self.imageView.image = image
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController!, didFinishCancelled cancelled: Bool)
    {
        dismiss(animated: true, completion: nil)
        cropViewController.dismiss(animated: true) { () -> Void in  }
    }
    
    
    //MARK: - Text Field Delegates -
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        
        let buttonPosition          = textField.convert(CGRect(), to: self.mTableDealerShipDetails)
        var indexPath: IndexPath?   = self.mTableDealerShipDetails.indexPathForRow(at: CGPoint(x: buttonPosition.origin.x, y: buttonPosition.origin.y))
        
        if (indexPath != nil) {
            let dictInfo = (self.mArrayDealershipInfo.object(at: (indexPath?.section)!) as! NSMutableArray).object(at: (indexPath?.row)!) as! NSMutableDictionary
            dictInfo.setValue(textField.text!, forKey: dictInfo.allKeys[0] as! String)
            (self.mArrayDealershipInfo.object(at: (indexPath?.section)!) as! NSMutableArray).replaceObject(at: (indexPath?.row)!, with: dictInfo)
        }else{
            print("May be later")
        }
        
        textField.text          = textField.text?.trimmingCharacters(in: .whitespaces)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength  = currentCharacterCount + string.characters.count - range.length
        return newLength <= 30
    }
    
    //MARK: - Text View Delegates -
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        let currentCharacterCount = textView.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength  = currentCharacterCount + text.characters.count - range.length
        return newLength <= 150
    }
    
    func saveDealershipInfo () {
        
        
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show(withStatus: "Please wait...", maskType: SVProgressHUDMaskType.gradient)
        }
        
        let servicesManager = ServicesManager()
        let parmDict        = NSMutableDictionary()
        parmDict.setValue("PUT", forKey: "_method")
        parmDict.setValue(self.mDealershipInfoDict.value(forKey: "id") as! NSNumber, forKey: "dealer_ID")
        parmDict.setValue(self.mTextFieldDealershipTitle.text!, forKey: "name")
        
        
        
        if let value = ((self.mArrayDealershipInfo.object(at: 0) as! NSMutableArray).object(at: 0) as! NSMutableDictionary).value(forKey: "phone_number") as? String {
            parmDict.setValue(value, forKey: "phone_number")
        }
        
        if let value = ((self.mArrayDealershipInfo.object(at: 0) as! NSMutableArray).object(at: 1) as! NSMutableDictionary).value(forKey: "website") as? String {
            parmDict.setValue(value, forKey: "website")
        }
        
        if let value = ((self.mArrayDealershipInfo.object(at: 0) as! NSMutableArray).object(at: 2) as! NSMutableDictionary).value(forKey: "address") as? String {
            parmDict.setValue(value, forKey: "address")
        }
        
        if let value = ((self.mArrayDealershipInfo.object(at: 0) as! NSMutableArray).object(at: 3) as! NSMutableDictionary).value(forKey: "city") as? String {
            parmDict.setValue(value, forKey: "city")
        }
        
        if ((self.mArrayDealershipInfo.object(at: 0) as! NSMutableArray).object(at: 4) as! NSMutableDictionary).value(forKey: "zip") as? String != "" {
            parmDict.setValue(((self.mArrayDealershipInfo.object(at: 0) as! NSMutableArray).object(at: 4) as! NSMutableDictionary).value(forKey: "zip") as? String, forKey: "zip")
        }
        
        if ((self.mArrayDealershipInfo.object(at: 1) as! NSMutableArray).object(at: 0) as! NSMutableDictionary).value(forKey: "facebook") as? String != "" {
            parmDict.setValue(((self.mArrayDealershipInfo.object(at: 1) as! NSMutableArray).object(at: 0) as! NSMutableDictionary).value(forKey: "facebook") as? String, forKey: "facebook")
        }
        
        if ((self.mArrayDealershipInfo.object(at: 1) as! NSMutableArray).object(at: 1) as! NSMutableDictionary).value(forKey: "instagram") as? String != "" {
            parmDict.setValue(((self.mArrayDealershipInfo.object(at: 1) as! NSMutableArray).object(at: 1) as! NSMutableDictionary).value(forKey: "instagram") as? String, forKey: "instagram")
        }
        
        if ((self.mArrayDealershipInfo.object(at: 1) as! NSMutableArray).object(at: 2) as! NSMutableDictionary).value(forKey: "google_plus") as? String != "" {
            parmDict.setValue(((self.mArrayDealershipInfo.object(at: 1) as! NSMutableArray).object(at: 2) as! NSMutableDictionary).value(forKey: "google_plus") as? String, forKey: "google_plus")
        }
        
        if ((self.mArrayDealershipInfo.object(at: 1) as! NSMutableArray).object(at: 3) as! NSMutableDictionary).value(forKey: "twitter") as? String != "" {
            parmDict.setValue(((self.mArrayDealershipInfo.object(at: 1) as! NSMutableArray).object(at: 3) as! NSMutableDictionary).value(forKey: "twitter") as? String, forKey: "twitter")
        }
        
        if ((self.mArrayDealershipInfo.object(at: 1) as! NSMutableArray).object(at: 4) as! NSMutableDictionary).value(forKey: "whatsapp") as? String != "" {
            parmDict.setValue(((self.mArrayDealershipInfo.object(at: 1) as! NSMutableArray).object(at: 4) as! NSMutableDictionary).value(forKey: "whatsapp") as? String, forKey: "whatsapp")
        }
        
        
        if  self.mTextViewDealershipInfo.text != "" {
            parmDict.setValue(self.mTextViewDealershipInfo.text! , forKey: "short_description")
        }
        
        parmDict.setValue(self.mDealershipInfoDict.value(forKey: "registration_number"), forKey: "registration_number")
        //parmDict.setValue(self.mImageData, forKey: "photo")
        
        servicesManager.editDealership( parameters: parmDict, image : self.mImageDealership , completion: { (result, error) in
            DispatchQueue.main.async {
                
                
                if let success = result.value(forKey: "updated") as? NSNumber {
                    
                    SVProgressHUD.dismiss()
                    print("Updated Successfully \(success)")
                    
                    self.isEditMode                                             = false
                    self.mButtonCamera.isHidden                                  = true
                    self.mTextFieldDealershipTitle.isUserInteractionEnabled     = false
                    self.mTextViewDealershipInfo.isUserInteractionEnabled       = false
                    
                    SDImageCache.shared().removeImage(forKey:self.mDealershipInfoDict.value(forKey: "profile_image_large_url") as! String , fromDisk: true)
                    SDImageCache.shared().removeImage(forKey:self.mDealershipInfoDict.value(forKey: "profile_image_medium_url") as! String , fromDisk: true)
                    
                    TSMessage.showNotification(in: self , title: "\nInfo updated successfully.", subtitle: nil, type: TSMessageNotificationType.message)
                    let editButtonItem      = UIBarButtonItem.init(image: UIImage(named:"edit_white"), style: .plain, target: self, action: #selector(self.editAction))
                    self.navigationItem.rightBarButtonItems = [editButtonItem]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh_Dealerships_List"), object: nil)
                    
                }else{
                    
                    
                    if let value = result.value(forKey: "error") {
                        
                        TSMessage.showNotification(in: self , title: "\n\(result.value(forKey: "error") as! String)", subtitle: nil, type: TSMessageNotificationType.message)
                        
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
                                        self.saveDealershipInfo()
                                    }
                                }
                            })
                        }else{
                            SVProgressHUD.dismiss()
                        }
                    }else{
                        SVProgressHUD.dismiss()
                        
                        if let value = result.value(forKey: "email") {
                            
                            print(value)
                            TSMessage.showNotification(in: self , title: "\n The email must be a valid email address.", subtitle: nil, type: TSMessageNotificationType.message)
                            
                        }
                            
                        else if let value = result.value(forKey: "facebook") {
                            
                            print(value)
                            TSMessage.showNotification(in: self , title: "\n The facebook format is invalid.", subtitle: nil, type: TSMessageNotificationType.message)
                            
                        }
                            
                        else if let value = result.value(forKey: "instagram") {
                            
                            print(value)
                            TSMessage.showNotification(in: self , title: "\n The instagram format is invalid.", subtitle: nil, type: TSMessageNotificationType.message)
                            
                        }
                            
                        else if let value = result.value(forKey: "google_plus") {
                            
                            print(value)
                            TSMessage.showNotification(in: self , title: "\n The Google Plus format is invalid.", subtitle: nil, type: TSMessageNotificationType.message)
                            
                        }
                            
                        else if let value = result.value(forKey: "twitter") {
                            
                            print(value)
                            TSMessage.showNotification(in: self , title: "\n The Twitter format is invalid.", subtitle: nil, type: TSMessageNotificationType.message)
                            
                        }
                            
                        else if let value = result.value(forKey: "twitter") {
                            
                            print(value)
                            TSMessage.showNotification(in: self , title: "\n The Twitter format is invalid.", subtitle: nil, type: TSMessageNotificationType.message)
                            
                        }
                            
                        else if let value = result.value(forKey: "whatsapp") {
                            
                            print(value)
                            TSMessage.showNotification(in: self , title: "\n Whatsapp is invalid phone number, example: +1234567890", subtitle: nil, type: TSMessageNotificationType.message)
                            
                        }
                            
                        else if let value = result.value(forKey: "photo") {
                            
                            print(value)
                            TSMessage.showNotification(in: self , title: "\n The photo has invalid image dimensions.", subtitle: nil, type: TSMessageNotificationType.message)
                            
                        }
                    }
                    
                }
                
            }
        })
        
    }
    
    func validateWebsiteUrl (stringURL : NSString) -> Bool {
        
        let urlRegEx    = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate   = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        _               = NSPredicate.withSubstitutionVariables(predicate)
        return predicate.evaluate(with: stringURL)
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

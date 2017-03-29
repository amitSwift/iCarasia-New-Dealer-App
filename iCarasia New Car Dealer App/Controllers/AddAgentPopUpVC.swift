//
//  AddAgentPopUpVC.swift
//  iCarasia New Car Dealer App
//
//  Created by Amit Verma  on 3/20/17.
//  Copyright © 2017 Raman Kant. All rights reserved.
//

import UIKit

protocol MJPopUpPopupDelegate : NSObjectProtocol{
    
    func cancelButtonClickedAddAgent(_ secondDetailViewController: AddAgentPopUpVC , number : String)
    func rightButtonClickedAddAgent(_ secondDetailViewController: AddAgentPopUpVC , number : String)
}

class AddAgentPopUpVC: UIViewController , UITextFieldDelegate {

    
    @IBOutlet weak var mTextFieldPhone      : UITextField!
    @IBOutlet weak var mButtonRight         : UIButton!
    @IBOutlet weak var mButtonCross         : UIButton!
    
    public var delegate: MJPopUpPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        
        //let delegate = UIApplication.shared.delegate as! AppDelegate
        //delegate.enableIQKeyBoardManager()
        
        mTextFieldPhone.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view.
        
        //let delegate = UIApplication.shared.delegate as! AppDelegate
        //delegate.disableIQKeyBoardManager()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        
        self.mTextFieldPhone.resignFirstResponder()
        self.delegate?.cancelButtonClickedAddAgent(self , number: self.mTextFieldPhone.text!)
    }
    
    
    @IBAction func rightAction(_ sender: UIButton) {
        
        if (mTextFieldPhone.text?.characters.count)! < 10 {
            
            TSMessage.showNotification(in: self , title: "\n Phone number must contains 10 digits.", subtitle: nil, type: TSMessageNotificationType.message)
            return
        }
        
        self.mTextFieldPhone.resignFirstResponder()
        self.delegate?.rightButtonClickedAddAgent(self , number: self.mTextFieldPhone.text!)
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength  = currentCharacterCount + string.characters.count - range.length
        /*
         if text == "" && range.length > 0 {
         if let oldCount  = Int(self.mLabelCharCount.text!) {
         let newCount = oldCount + range.length
         self.mLabelCharCount.text   = "\(newCount)"
         }
         
         }else if text != "" && range.location < 250{
         if let oldCount  = Int(self.mLabelCharCount.text!) {
         let newCount = oldCount - text.characters.count
         self.mLabelCharCount.text   = "\(newCount)"
         }
         }*/
        return newLength <= 18
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

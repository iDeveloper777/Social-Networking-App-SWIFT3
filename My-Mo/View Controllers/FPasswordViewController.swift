//
//  FPasswordViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 10/11/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Firebase

class FPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var view_Email: UIView!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_ConfirmEmail: UITextField!
    
    //-----
    var tmpTextFeild: UITextField!
//    var loadingNotification:MBProgressHUD? = nil
    //---
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }

    func setLayout(){
        view_Email.layer.borderWidth = 1.0
        view_Email.layer.cornerRadius = 5.0
        view_Email.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.6).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Buttons' Event
    @IBAction func click_btn_Back(_ sender: AnyObject) {
        hideKeyboard()
//        self.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_btn_ResetPassword(_ sender: AnyObject) {
        hideKeyboard()
        
        if (txt_Email.text == "Email" || txt_Email.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterEmail, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (txt_ConfirmEmail.text == "Confirm Email" || txt_ConfirmEmail.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterEmail, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (txt_Email.text != txt_ConfirmEmail.text){
            COMMON.methodForAlert(titleString: kAppName, messageString: kConfirmEmail, OKButton: kOkButton, CancelButton: "", viewController: self)
            
        }else if (!COMMON.methodIsValidEmailAddress(email: txt_Email.text!) ||
            !COMMON.methodIsValidEmailAddress(email: txt_ConfirmEmail.text!)){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterValidEmail, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else{
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
            
//            SendPassword()
            SendPasswordWithFirebase()
        }
    }
    
    func SendPasswordWithFirebase(){
        FirebaseModule.shareInstance.SendPasswordWithFirebase(email: txt_Email.text!){ (response: String?, error: Error?) in
            if (error == nil){
                if (response == "success"){
                    COMMON.methodForAlert(titleString: kAppName, messageString: kSuccessResetPassword, OKButton: kOkButton, CancelButton: "", viewController: self)
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: kErrorResetPassword, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
    }
    
    //MARK: - SendPassword()
    func SendPassword(){
        let parameters = ["email":txt_Email.text]
        Alamofire.request(kAPI_ForgotPassword, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    COMMON.methodForAlert(titleString: kAppName, messageString: jsonObject["message"].stringValue, OKButton: kOkButton, CancelButton: "", viewController: self)
                    
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: jsonObject["message"].stringValue, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kLoginRequest, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }
    
    //MARK: - Move UIView When Keyboard appear
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tmpTextFeild = textField
        //        animateViewMoving(true, moveValue: 167)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        tmpTextFeild = nil
        //        animateViewMoving(false, moveValue: 167)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboard(){
        if tmpTextFeild != nil{
            tmpTextFeild.resignFirstResponder()
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txt_Email.resignFirstResponder()
        self.txt_ConfirmEmail.resignFirstResponder()
    }
}

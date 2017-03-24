//
//  SignUpViewController.swift
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

protocol PushViewControllerDelegate: class {
    func pushTabViewController(vc: UIViewController)
}

class SignUpViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var view_Main: UIView!
    
    @IBOutlet weak var view_EditBoard: UIView!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var txt_UserName: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_ConfirmPassword: UITextField!
    @IBOutlet weak var txt_Mobile: UITextField!
    
    //---
//    var loadingNotification:MBProgressHUD? = nil
    var bScreenUp = 0;
    var tmpTextFeild: UITextField! = nil
    weak var delegate: PushViewControllerDelegate?
    
    //----
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }
    
    func setLayout(){
        view_EditBoard.layer.borderWidth = 1.0
        view_EditBoard.layer.cornerRadius = 5.0
        view_EditBoard.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.6).cgColor
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
    
    @IBAction func click_btn_SignUp(_ sender: AnyObject) {
        
        if (tmpTextFeild != nil){
            tmpTextFeild.resignFirstResponder()
            hideKeyboard()
        }
        
        if (txt_Email.text == "Email" || txt_Email.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterEmail, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (txt_Name.text == "Name" || txt_Name.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterName, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (txt_UserName.text == "User Name" || txt_UserName.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterUserName, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (txt_Password.text == "Password" || txt_Password.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterPassword, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (txt_ConfirmPassword.text == "Confirm Password" || txt_ConfirmPassword.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterPassword, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (txt_Mobile.text == "Mobile" || txt_Mobile.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterMobile, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (!COMMON.methodIsValidEmailAddress(email: txt_Email.text!)){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterValidEmail, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (txt_Password.text != txt_ConfirmPassword.text){
            COMMON.methodForAlert(titleString: kAppName, messageString: kConfirmPassword, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else{
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
            
            ConfirmRegisteredUsername()
//            SignUpWithFirebase()
//            SignUp()
        }
    }
    
    //MARK: - SignUpWithFirebase
    func ConfirmRegisteredUsername(){
        FirebaseModule.shareInstance.ConfirmRegisteredUsername(username: txt_UserName.text){ (response: String?, error: Error?) in
            if (error == nil){
                if (response == ""){
                    self.SignUpWithFirebase()
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: kErrorUsername, OKButton: kOkButton, CancelButton: "", viewController: self)
                    self.txt_UserName.becomeFirstResponder()
                }                
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
    }
    
    func SignUpWithFirebase(){
        FirebaseModule.shareInstance.SignUpWithEmail(email: txt_Email.text, password: txt_Password.text, username: txt_UserName.text, name: txt_Name.text, mobile: txt_Mobile.text){ (response: String?, error: Error?) in
            
            if (error == nil){
                FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
                    if (error == nil){
                        _ = self.navigationController?.popViewController(animated: true)
//                        COMMON.methodForAlert(titleString: kAppName, messageString: kSignUpSuccess, OKButton: kOkButton, CancelButton: "", viewController: self)
                    }else{
                        COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                    }
                })
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
    }
    
    //MARK: - SignUp
    func SignUp(){
        
        let parameters = ["username":txt_UserName.text,
                          "password":txt_Password.text,
                          "email":txt_Email.text,
                          "name":txt_Name.text,
                          "mobile":txt_Mobile.text]
        Alamofire.request(kAPI_Registration, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    USER.initUserData()
                    USER.initSignUpUserDataWithJSON(json: jsonObject["message"])
                    
//                    self.dismiss(animated: false, completion: { () -> Void   in
//                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TapBarView") as! TabBarViewController
//                        self.delegate?.pushTabViewController(vc: viewController)
//                    })
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TapBarView") as! TabBarViewController
                    self.navigationController?.pushViewController(viewController, animated: true)
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
        
        if (bScreenUp == 0 && textField.tag > 399){ //Confirm Password or Mobile
            bScreenUp = 1
            animateViewMoving(up: true, moveValue: 167)
        }
        
//        if (bScreenUp == 1 && textField.tag < 500){ //Screen Up
//            bScreenUp = 0
//            animateViewMoving(up: false, moveValue: 167)
//        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        tmpTextFeild = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5, animations: {
            self.hideKeyboard()
        })
        
        return true
    }
    
    func hideKeyboard(){
        if (bScreenUp == 1){ //Screen Up
            bScreenUp = 0
            animateViewMoving(up: false, moveValue: 167)
        }
        
        if tmpTextFeild != nil{
            UIView.animate(withDuration: 0.5, animations: {
                self.tmpTextFeild.resignFirstResponder()
            })
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.5
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view_Main.frame = self.view_Main.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
//        self.txt_Email.resignFirstResponder()
//        self.txt_Name.resignFirstResponder()
//        self.txt_UserName.resignFirstResponder()
//        self.txt_Password.resignFirstResponder()
//        self.txt_ConfirmPassword.resignFirstResponder()
//        self.txt_Mobile.resignFirstResponder()
    }
    
}

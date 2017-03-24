//
//  LogInViewController.swift
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

class LogInViewController: UIViewController ,UITextFieldDelegate, UIAlertViewDelegate, PushViewControllerDelegate{
    
    @IBOutlet weak var view_Login: UIView!
    @IBOutlet weak var txt_UserName: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    
//    var loadingNotification:MBProgressHUD? = nil
    var strUserName: String = ""
    var strPassword: String = ""
    var strEMail: String = ""
    var strLogined: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setLayout()
        getUserNameAndPassword()
    }
    
    func setLayout(){
        view_Login.layer.borderWidth = 1.0
        view_Login.layer.cornerRadius = 5.0
        view_Login.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.6).cgColor
    }
    
    func getUserNameAndPassword(){
        
        strUserName = DATAKEEPER.getUserName()
        strPassword = DATAKEEPER.getPassword()
        strLogined = DATAKEEPER.getLogined()
        
        txt_UserName.text = strUserName
        txt_Password.text = strPassword
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Buttons' Events
    @IBAction func click_btn_Login(_ sender: AnyObject) {
        self.txt_UserName.resignFirstResponder()
        self.txt_Password.resignFirstResponder()
        
        if (txt_UserName.text == "User Name" || txt_UserName.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterUserName, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (txt_Password.text == "Password" || txt_Password.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterPassword, OKButton: kOkButton, CancelButton: "", viewController: self)
            
        }else{
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
            
            strUserName = txt_UserName.text!
            strPassword = txt_Password.text!
            
            appDelegate.array_Host_Friends = []
            appDelegate.array_HostUsers = []
            appDelegate.array_BlockUsers = []
            appDelegate.array_Hosts = []
            
//            LogIn()
            ConfirmRegisteredUsername()
        }
    }
    
    @IBAction func click_btn_ForgotPassword(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "FPasswordView") as! FPasswordViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func click_btn_SignUp(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView") as! SignUpViewController
//        viewController.delegate = self
//        self.present(viewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Firebase
    func isVerifiedEmail(){
        if (FIRAuth.auth()?.currentUser?.isEmailVerified == true){
            DATAKEEPER.updateUserName(username: self.strUserName)
            DATAKEEPER.updatePassword(password: self.strPassword)
            DATAKEEPER.updateLogined(logined: "yes")
            
            USER.initUserData()
            USER.initUserDataWithUserDefault()
            
            USER.initUserDataWithFirebase(){ (response: String?, error: Error?) in
                if (error == nil){
                    USER.updateUserDataWithUserDefault()
                    
                    USER.password = DATAKEEPER.getPassword()
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TapBarView") as! TabBarViewController
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
            }
        }else{
            COMMON.methodForAlert(titleString: kAppName, messageString: kVerifiedEmail, OKButton: kOkButton, CancelButton: "", viewController: self)
        }
    }
    
    func ConfirmRegisteredUsername(){
        FirebaseModule.shareInstance.ConfirmRegisteredUsername(username: txt_UserName.text){ (response: String?, error: Error?) in
            if (error == nil){
                if (response == ""){
                    COMMON.methodForAlert(titleString: kAppName, messageString: kLoginNoUserFailed, OKButton: kOkButton, CancelButton: "", viewController: self)
                }else{
                    self.strEMail = response!
                    self.LogInWithFirebase()
                }
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
    }

    func LogInWithFirebase(){
        FirebaseModule.shareInstance.SignInWithEmail(email: strEMail, password: txt_Password.text){ (response: String?, error: Error?) in
            
            if (error == nil){
                self.isVerifiedEmail()
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
    }

    //MARK: - LogIn
    func LogIn(){
        let parameters = ["username":strUserName, "password":strPassword]
        Alamofire.request(kAPI_Login, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    
                    DATAKEEPER.updateUserName(username: self.strUserName)
                    DATAKEEPER.updatePassword(password: self.strPassword)
                    DATAKEEPER.updateLogined(logined: "yes")
                    
                    USER.initUserData()
                    USER.initUserDataWithUserDefault()
                    
//                    USER.initUserDataWithJSON(json: jsonObject["data"])
                    
                    USER.updateUserDataWithUserDefault()
                    
                    USER.password = DATAKEEPER.getPassword()
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TapBarView") as! TabBarViewController
            
                    self.navigationController?.pushViewController(viewController, animated: true)

                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: "Login Failed", OKButton: kOkButton, CancelButton: "", viewController: self)
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
        
        //        animateViewMoving(true, moveValue: 167)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        animateViewMoving(false, moveValue: 167)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        self.txt_UserName.resignFirstResponder()
        self.txt_Password.resignFirstResponder()
    }
    
    //MARK: - PushViewControllerDelegate
    func pushTabViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

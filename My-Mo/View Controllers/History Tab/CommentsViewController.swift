//
//  CommentsViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/9/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CommentsTBCellDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    @IBOutlet weak var view_InputBoard: UIView!
    @IBOutlet weak var txt_Comment: UITextField!
    
//    var loadingNotification:MBProgressHUD? = nil
    
    var motiff_id:Int = 0
    var array_Comments: [Comment] = []
    var swipeArray:[Int] = []
    var workingIndexPath: IndexPath? = nil
    var keyboardHeight:CGFloat = 216

    override func viewDidLoad() {
        super.viewDidLoad()

        if (motiff_id != 0){
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
            
            loadCommentsFromServer()
        }
        
        setLayout()
    }

    func setLayout(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: - loadCommentsFromServer
    func loadCommentsFromServer(){
        
        let parameters = ["motiff_id":motiff_id]
        Alamofire.request(kApi_GetComments, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.fetchCommentsDataFromJSON(json: jsonObject["data"])
                    self.tbl_List.reloadData()
                    
                }else{
                    self.array_Comments = []
                    self.swipeArray = []
                    self.tbl_List.reloadData()
                    
                    
                    //                    COMMON.methodForAlert(titleString: kAppName, messageString: "Login Failed", OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }

    func fetchCommentsDataFromJSON(json: SwiftyJSON.JSON){
        array_Comments = []
        swipeArray = []
        
        for i in (0..<json.count) {
            let comment = Comment()
            
            comment.initCommentDataWithJSON(json: json[i])
            array_Comments.append(comment)
            swipeArray.append(0)
        }
    }

    func loadCommentsFromServerForAdding(){
        
        let parameters = ["motiff_id":motiff_id]
        Alamofire.request(kApi_GetComments, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            //            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.fetchCommentsDataFromJSONForAdding(json: jsonObject["data"])
                }else{
                    self.array_Comments = []
                    self.swipeArray = []
                    self.tbl_List.reloadData()
                    
                    
                    //                    COMMON.methodForAlert(titleString: kAppName, messageString: "Login Failed", OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }
    
    func fetchCommentsDataFromJSONForAdding(json: SwiftyJSON.JSON){
        let comment = Comment()
            
        comment.initCommentDataWithJSON(json: json[0])
        array_Comments.remove(at: 0)
        array_Comments.insert(comment, at: 0)
        
        self.tbl_List.reloadData()
    }
    
    // MARK: - Buttons' Event
    @IBAction func click_btn_Back(_ sender: AnyObject) {
        txt_Comment.resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_btn_SendComment(_ sender: Any) {
        txt_Comment.resignFirstResponder()
        
        if (txt_Comment.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: "Please input Comment", OKButton: kOkButton, CancelButton: "", viewController: self)
        }else{
            addComment()
        }
    }
    
    func addComment(){
        let parameters = ["user_id": USER.id, "motiff_id": motiff_id, "comment": txt_Comment.text ?? ""] as [String : Any]
        
        Alamofire.request(kApi_AddComment, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    let comment: Comment = Comment()
                    
                    comment.motiff_user = USER.id
                    comment.user_id = USER.id
                    comment.avatar = USER.avatar
                    comment.username = USER.username
                    comment.comment = self.txt_Comment.text!
                    
                    let date: Date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM"
                    
                    var strDate: String = formatter.string(from: date)
                    
                    formatter.dateFormat = "dd"
                    strDate = strDate + " " + formatter.string(from: date)
                    comment.date = strDate
                    
                    self.array_Comments.insert(comment, at: 0)
                    self.swipeArray.append(0)
                    
                    self.tbl_List.reloadData()
                    
                    self.txt_Comment.text = ""
                    
                    self.loadCommentsFromServerForAdding()
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: jsonObject["message"].stringValue, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
        }
    }
    
    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentsTBCell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell01") as! CommentsTBCell
        cell.cellDelegate = self
        
        let comment: Comment = array_Comments[indexPath.row]

        cell.img_Avatar.sd_setImage(with: URL(string: comment.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        cell.lbl_Name.text = comment.username
        cell.lbl_Comment.text = comment.comment
        cell.lbl_Date.text = comment.date
        
        //SwipeGesture
        cell.tag = indexPath.row
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftCell))
        swipeLeftGesture.direction = .left
        cell.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightCell))
        swipeRightGesture.direction = .right
        cell.addGestureRecognizer(swipeRightGesture)
        
        if (swipeArray[indexPath.row] == 0){
            cell.view_Swipe.frame = cell.contentView.frame
        }else{
            var nPosition: CGFloat = 0
            if (comment.following == "yes"){
                nPosition = 50
                cell.btn_Follow.isHidden = true
            }else {
                nPosition = 100
                cell.btn_Follow.isHidden = false
            }
            
            let rect:CGRect = CGRect(x: -nPosition, y: COMMON.Y(view: cell.contentView), width: COMMON.WIDTH(view: cell.contentView), height: COMMON.HEIGHT(view: cell.contentView))
            
            cell.view_Swipe.frame = rect
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }


    //MARK: - Swipe Getures
    func swipeLeftCell(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! CommentsTBCell
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!

        if (workingIndexPath != nil && (workingIndexPath?.row)! < array_Comments.count){
            let preCell: CommentsTBCell = tbl_List.cellForRow(at: workingIndexPath!) as! CommentsTBCell
            
            if (swipeArray[(workingIndexPath?.row)!] == 1){
                swipeArray[(workingIndexPath?.row)!] = 0
                
                UIView.animate(withDuration: 0.5, animations: {
                    preCell.view_Swipe.frame = preCell.contentView.frame
                })
            }

        }
        
        workingIndexPath = indexPath
        swipeArray[cell.tag] = 1
        let comment: Comment = array_Comments[cell.tag]
        
        if (swipeArray[cell.tag] == 1){
            var nPosition: CGFloat = 0
            if (comment.following == "yes"){
                nPosition = 50
                cell.btn_Follow.isHidden = true
            }else {
                nPosition = 100
                cell.btn_Follow.isHidden = false
            }

            UIView.animate(withDuration: 0.5, animations: {
                cell.view_Swipe.frame = CGRect(x:  -nPosition, y: COMMON.Y(view: cell.contentView), width: COMMON.WIDTH(view: cell.contentView), height: COMMON.HEIGHT(view: cell.contentView))
            })
        }
    }
    
    
    func swipeRightCell(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! CommentsTBCell
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        
        workingIndexPath = indexPath
        swipeArray[cell.tag] = 0
        
        if (swipeArray[cell.tag] == 0){
            UIView.animate(withDuration: 0.5, animations: {
                cell.view_Swipe.frame = cell.contentView.frame
            })
        }
    }
    
    //MARK: - CommentsTBCellDelegate
    func select_btn_Follow(cell: CommentsTBCell) {
        let comment: Comment = array_Comments[cell.tag]
        
        let parameters = ["user_id": USER.id, "followee": comment.user_id]
        Alamofire.request(KApi_JoinFriends, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.loadCommentsFromServer()
                    
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: jsonObject["message"].stringValue, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }
    
    func select_btn_Delete(cell: CommentsTBCell) {
        let comment: Comment = array_Comments[cell.tag]
        
        let parameters = ["user_id":USER.id, "comment_id":comment.comment_id] as [String : Any]
        
        Alamofire.request(kApi_DeleteComment, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.array_Comments.remove(at: cell.tag)
                    self.swipeArray.remove(at: cell.tag)
                    
                    self.tbl_List.reloadData()
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: jsonObject["message"].stringValue, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
        }
    }
    
    //MARK: - Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            //            showKeyboard()
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txt_Comment.resignFirstResponder()
        
        switch textField.tag {
        case 1:
            //            hideKeyboard()
            break
        default:
            break
        }
        return true
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        keyboardHeight = keyboardHeight - 48
        
        showKeyboard()
    }
    
    func keyboardWillHide(notification:NSNotification){
        hideKeyboard()
    }
    
    //MARK: - Show and Hide Keyboard
    func showKeyboard(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionCrossDissolve, animations: {() -> Void in
            UIApplication.shared.sendAction(#selector(self.becomeFirstResponder), to: nil, from: nil, for: nil)
            self.view_InputBoard.frame = CGRect(x: self.view_InputBoard.frame.origin.x,
                                                y: self.view_Table.frame.size.height - self.keyboardHeight,
                                                width: self.view_InputBoard.frame.size.width,
                                                height: self.view_InputBoard.frame.size.height)
        }, completion: {(finished: Bool) -> Void in
            self.goToTop()
        })
    }
    
    func goToTop(){
        if (array_Comments.count > 1){
            let lastIndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
            
            tbl_List.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }        
    }
    
    func hideKeyboard(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionCrossDissolve, animations: {() -> Void in
            self.view_InputBoard.frame = CGRect(x: self.view_InputBoard.frame.origin.x,
                                                y: self.view_Table.frame.size.height,
                                                width: self.view_InputBoard.frame.size.width,
                                                height: self.view_InputBoard.frame.size.height)
        }, completion: {(finished: Bool) -> Void in
            
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

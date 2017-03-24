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
import Firebase

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CommentsTBCellDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    @IBOutlet weak var view_InputBoard: UIView!
    @IBOutlet weak var txt_Comment: UITextField!
    @IBOutlet weak var txtview_Comment: UITextView!
    
    @IBOutlet weak var lbl_Temp_Comment: UILabel!
    
    
//    var loadingNotification:MBProgressHUD? = nil
    
    var host: Host? = Host()
    var motiff_id: String = ""
    var swipeArray:[Int] = []
    var workingIndexPath: IndexPath? = nil
    var keyboardHeight:CGFloat = 0

    var rect_InputView: CGRect = CGRect()
    var rect_TextComment: CGRect = CGRect()
    var rect_TextCommentOriginal: CGRect = CGRect()
    var rect_InputViewOriginal: CGRect = CGRect()
    
    var refresh_Flag: Int = 0
    let refreshControl: UIRefreshControl = UIRefreshControl()
//    let petRefreshControl: PetRefreshControl = PetRefreshControl()
    
    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        
        swipeArray = []
        loadMotiffFromFirebase()
    }

    func setLayout(){
        rect_InputView = view_InputBoard.frame
        rect_TextComment = txtview_Comment.frame
        rect_TextCommentOriginal = txtview_Comment.frame
        rect_InputViewOriginal = view_InputBoard.frame
        
        txtview_Comment.textColor = UIColor.lightGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        refreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
        tbl_List.addSubview(refreshControl)
        
//        petRefreshControl.tintColor = UIColor.clear
//        petRefreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
//        tbl_List.addSubview(petRefreshControl)
    }
    
    
    
    // MARK: - Buttons' Event
    @IBAction func click_btn_Back(_ sender: AnyObject) {
        txt_Comment.resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_btn_SendComment(_ sender: Any) {
//        txtview_Comment.resignFirstResponder()
        
        let string: String = txtview_Comment.text
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        let trimmedString = (string.trimmingCharacters(in: whitespace)) as String
        
        if (txtview_Comment.text == "" || (txtview_Comment.text == "Comment" && txtview_Comment.textColor == UIColor.lightGray) || trimmedString == ""){
//            COMMON.methodForAlert(titleString: kAppName, messageString: "Please input Comment", OKButton: kOkButton, CancelButton: "", viewController: self)
            
            self.txtview_Comment.text = "Comment"
            self.txtview_Comment.textColor = UIColor.lightGray
            
            self.rect_TextComment = self.rect_TextCommentOriginal
            self.rect_InputView = self.rect_InputViewOriginal
            
            if (keyboardHeight != 0){
                self.rect_InputView.origin.y = COMMON.HEIGHT(view: self.view_Main) - self.rect_InputViewOriginal.size.height - self.keyboardHeight
            }
            
            self.view_InputBoard.frame = rect_InputView
            self.txtview_Comment.frame = self.rect_TextCommentOriginal
            
            self.setTableViewSize()
        }else{
            uploadCommentToFirebase()
        }
    }
    
    
    
    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let comment: Comment = (host?.comments_array[indexPath.row])!
        let size: CGSize = COMMON.getLabelSize(text: comment.comment as NSString, size: CGSize(width: Main_Screen_Width - 80, height: 20))
        
        if (size.height > 20){
            return 40 + size.height
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentsTBCell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell01") as! CommentsTBCell
        cell.cellDelegate = self
        
        let comment: Comment = (host?.comments_array[indexPath.row])!

        cell.img_Avatar.sd_setImage(with: URL(string: comment.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        cell.lbl_Name.text = comment.username
        
        cell.lbl_Comment.text = comment.comment
        let size: CGSize = COMMON.getLabelSize(text: comment.comment as NSString, size: CGSize(width: COMMON.WIDTH(view: cell.contentView) - 80, height: 20))
        
        let rect: CGRect = CGRect(x: COMMON.X(view: cell.lbl_Comment),
                                  y: COMMON.Y(view: cell.lbl_Comment),
                                  width: COMMON.WIDTH(view: cell.lbl_Comment),
                                  height: size.height)
        
        
        cell.lbl_Comment.frame = rect
        
        cell.lbl_Date.adjustsFontSizeToFitWidth = true
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
            if (isFollowingUser(Id: comment.user_id) == true){
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
        txtview_Comment.resignFirstResponder()
    }

    //MARK: - isFollowingUser
    func isFollowingUser(Id: String) -> Bool {
        var flag: Bool = false
        
        if (Id == USER.id){ return true}
        
        for i in (0..<appDelegate.array_Following_Users.count){
            let user: Follow_User = appDelegate.array_Following_Users[i]
            
            if (user.id == Id){
                flag = true
                break
            }
        }
        return flag
    }
    
    //MARK: - Swipe Getures
    func swipeLeftCell(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! CommentsTBCell
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!

        if (workingIndexPath != nil && (workingIndexPath?.row)! < (host?.comments_array.count)!){
            
            if (swipeArray[(workingIndexPath?.row)!] == 1){
                swipeArray[(workingIndexPath?.row)!] = 0
                
                let preCell: CommentsTBCell? = tbl_List.cellForRow(at: workingIndexPath!) as? CommentsTBCell
                
                if (preCell != nil){
                    UIView.animate(withDuration: 0.5, animations: {
                        preCell?.view_Swipe.frame = (preCell?.contentView.frame)!
                    })
                }
            }

        }
        
        workingIndexPath = indexPath
        swipeArray[cell.tag] = 1
        let comment: Comment = (host?.comments_array[cell.tag])!
        
        if (swipeArray[cell.tag] == 1){
            var nPosition: CGFloat = 0
            if (isFollowingUser(Id: comment.user_id) == true){
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
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        let comment: Comment = (host?.comments_array[cell.tag])!
        
        FirebaseModule.shareInstance.FollowingUser(id: USER.id, following_id: comment.user_id){
            (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                let follow_user: Follow_User = Follow_User()
                
                for i in (0..<appDelegate.array_All_Users.count){
                    let user : User = appDelegate.array_All_Users[i]
                    
                    if (user.id == comment.user_id){
                        follow_user.id = user.id
                        follow_user.name = user.name
                        follow_user.username = user.username
                        follow_user.avatar = user.avatar
                        follow_user.motives = user.motives
                        follow_user.followers = user.followers
                        
                        self.swipeArray.remove(at: indexPath.row)
                        self.swipeArray.insert(0, at: indexPath.row)
                        
                        appDelegate.array_Following_Users.append(follow_user)
                        
                        //sort
                        if (appDelegate.array_Following_Users.count > 0){
                            for i in (0..<appDelegate.array_Following_Users.count-1){
                                var user: Follow_User = appDelegate.array_Following_Users[i]
                                for j in (i..<appDelegate.array_Following_Users.count){
                                    let user_compare: Follow_User = appDelegate.array_Following_Users[j]
                                    
                                    if (user.username.compare(user_compare.username) == .orderedAscending){
                                        
                                    }else if (user.username.compare(user_compare.username) == .orderedDescending){
                                        appDelegate.array_Following_Users.remove(at: i)
                                        appDelegate.array_Following_Users.insert(user_compare, at: i)
                                        
                                        appDelegate.array_Following_Users.remove(at: j)
                                        appDelegate.array_Following_Users.insert(user, at: j)
                                        
                                        user = user_compare
                                    }
                                }
                            }
                        }
                        
                        self.tbl_List.reloadData()
                        break
                    }
                }
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
        
        FirebaseModule.shareInstance.IncreaseUserFollowings(id: USER.id, following_id: comment.user_id){ (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
    }
    
    func select_btn_Delete(cell: CommentsTBCell) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        let comment: Comment = (host?.comments_array[cell.tag])!
        
        FirebaseModule.shareInstance.delete_Comment(host: host!, comment: comment)
        {(response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                self.swipeArray.remove(at: indexPath.row)
                self.host?.comments_array.remove(at: indexPath.row)
                
                self.tbl_List.reloadData()
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtview_Comment.resignFirstResponder()
    }
    
    //MARK: - Text View Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (txtview_Comment.text == "Comment" && txtview_Comment.textColor == UIColor.lightGray){
            txtview_Comment.text = ""
        }
        txtview_Comment.becomeFirstResponder()
        txtview_Comment.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (txtview_Comment.text == "" && txtview_Comment.textColor == UIColor.black){
            txtview_Comment.text = "Comment"
            txtview_Comment.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//        var textWidth = UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset).width
//        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
//        
//        let boundingRect = sizeOfString(string: newText, constrainedToWidth: Double(textWidth), font: textView.font!)
//        let numberOfLines = boundingRect.height / textView.font!.lineHeight;
        
        if(text == "\n") {
//            textView.text = textView.text + "\n"
            textView.resignFirstResponder()
            return false
        }
        
        if (txtview_Comment.text == "Comment" && txtview_Comment.textColor == UIColor.lightGray){
            txtview_Comment.text = ""
            txtview_Comment.textColor = UIColor.black
        }
        
        if (range.length == 1 && range.location == 0){
            txtview_Comment.text = "Comment"
            txtview_Comment.textColor = UIColor.lightGray
            return false
        }

        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height + 5)
        
        let rect: CGRect = CGRect(x: 0,
                                  y: COMMON.Y(view: view_InputBoard) - (newFrame.height - rect_TextComment.height),
                                  width: COMMON.WIDTH(view: view_InputBoard),
                                  height: COMMON.HEIGHT(view: view_InputBoard) + (newFrame.height - rect_TextComment.height))
        
        if (rect.origin.y > 150){
            rect_InputView = rect
            view_InputBoard.frame = rect_InputView
            
            var rect_temp: CGRect = txtview_Comment.frame
            rect_temp.size.height = newFrame.height
            txtview_Comment.frame = rect_temp
            rect_TextComment = newFrame
            
            setTableViewSize()
        }
        
        
        
        //        return numberOfLines <= 2;
        return true
    }
    
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: DBL_MAX),
                                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                         attributes: [NSFontAttributeName: font],
                                                         context: nil).size
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
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
        keyboardHeight = 0
        hideKeyboard()
    }
    
    //MARK: - Show and Hide Keyboard
    func setTableViewSize(){
        self.tbl_List.frame = CGRect(x: COMMON.X(view: self.tbl_List),
                                     y: COMMON.Y(view: self.tbl_List),
                                     width: COMMON.WIDTH(view: self.tbl_List),
                                     height: COMMON.Y(view: self.view_InputBoard))
    }
    
    func showKeyboard(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionCrossDissolve, animations: {() -> Void in
            UIApplication.shared.sendAction(#selector(self.becomeFirstResponder), to: nil, from: nil, for: nil)
            self.view_InputBoard.frame = CGRect(x: self.view_InputBoard.frame.origin.x,
                                                y: COMMON.HEIGHT(view: self.view_Main) - COMMON.HEIGHT(view: self.view_InputBoard) - self.keyboardHeight,
                                                width: self.view_InputBoard.frame.size.width,
                                                height: self.view_InputBoard.frame.size.height)
            
            self.setTableViewSize()
            
        }, completion: {(finished: Bool) -> Void in
            self.goToTop()
        })
    }
    
    func goToTop(){
        if ((host?.comments_array.count)! > 1){
            let lastIndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
            
            tbl_List.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }        
    }
    
    func hideKeyboard(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionCrossDissolve, animations: {() -> Void in
            self.view_InputBoard.frame = CGRect(x: self.view_InputBoard.frame.origin.x,
                                                y: COMMON.HEIGHT(view: self.view_Main) - COMMON.HEIGHT(view: self.view_InputBoard),
                                                width: self.view_InputBoard.frame.size.width,
                                                height: self.view_InputBoard.frame.size.height)
            
            self.setTableViewSize()
            
        }, completion: {(finished: Bool) -> Void in
            
            
        })
    }
    
    //MARK: - refreshAllDatas
    func refreshAllDatas(){
        refresh_Flag = 1
//        petRefreshControl.beginRefreshing()
        
        //        loadFollowingUsersFromServer()
        loadMotiffFromFirebase()
    }
    
    // MARK: - Firebase
    func loadMotiffFromFirebase(){
        if (host == nil){ return}
        
        FirebaseModule.shareInstance.get_Motiff_With_ID(id: (host?.id)!)
        { (response: NSArray?, error: Error?) in
            if (error == nil){
                self.swipeArray = []
                
                let array_motiffs: [Host] = response as! [Host]
                
                if (array_motiffs.count > 0){
                    self.host = array_motiffs[0]
                }else{
                    return
                }
                
                if (self.host?.comments_array.count != 0){
                    for _ in (0..<(self.host?.comments_array.count)!){
                        self.swipeArray.append(0)
                    }
                }
                
                self.tbl_List.reloadData()
                self.tbl_List.setContentOffset(CGPoint.zero, animated: true)
                
                self.refresh_Flag = 0
                self.refreshControl.endRefreshing()
                //                self.petRefreshControl.endRefreshing()
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                
                self.refresh_Flag = 0
                self.refreshControl.endRefreshing()
                //                self.petRefreshControl.endRefreshing()
            }
        }

    }
    
    func uploadCommentToFirebase(){
        FirebaseModule.shareInstance.upload_Comment(user: USER, host: host!, comment: txtview_Comment.text!)
        {(response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                self.txtview_Comment.text = "Comment"
                self.txtview_Comment.textColor = UIColor.lightGray
                
                self.rect_TextComment = self.rect_TextCommentOriginal
                self.rect_InputView = self.rect_InputViewOriginal
                self.rect_InputView.origin.y = COMMON.HEIGHT(view: self.view_Main) - self.rect_InputViewOriginal.size.height - self.keyboardHeight
                
                self.view_InputBoard.frame = self.rect_InputView
                self.txtview_Comment.frame = self.rect_TextCommentOriginal
                
                self.setTableViewSize()
                
                self.loadMotiffFromFirebase()
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
    }
    
    func loadSearchUsersFromFirebase(){
        var arr_temp: [User] = []
        
        FirebaseModule.shareInstance.getAllUsers()
            { (response: NSArray?, error: Error?) in
                if (error == nil){
                    for user_in in response!{
                        let user: User = User()
                        let dict = user_in as! NSDictionary
                        user.initUserDataWithDictionary(value: dict)
                        arr_temp.append(user)
                    }
                    appDelegate.array_All_Users = arr_temp
                    
                    self.loadFollowingsFromFirebase()
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
        }
    }
    
    func loadFollowingsFromFirebase(){
        var arr_temp: [Following] = []
        
        FirebaseModule.shareInstance.getAllFollowings()
            { (response: NSArray?, error: Error?) in
                if (error == nil){
                    for following_in in response!{
                        let following: Following = Following()
                        let dict = following_in as! NSDictionary
                        following.initFollowingDataWithDictionary(value: dict)
                        arr_temp.append(following)
                    }
                    appDelegate.array_All_Followings = arr_temp
                    
                    appDelegate.array_Following_Users = []
                    appDelegate.array_Follower_Users = []
                    
                    for i in (0..<appDelegate.array_All_Users.count){
                        let user: User = appDelegate.array_All_Users[i]
                        
                        //                        if (user.id == USER.id){ continue}
                        
                        for j in (0..<appDelegate.array_All_Followings.count){
                            let follow_user: Follow_User = Follow_User()
                            let following: Following = appDelegate.array_All_Followings[j]
                            
                            if (following.id == USER.id && following.following_id == user.id){
                                follow_user.id = user.id
                                follow_user.name = user.name
                                follow_user.username = user.username
                                follow_user.avatar = user.avatar
                                follow_user.motives = user.motives
                                follow_user.followers = user.followers
                                
                                appDelegate.array_Following_Users.append(follow_user)
                            }
                            
                            let follower_user: Follow_User = Follow_User()
                            if (following.following_id == USER.id && following.id == user.id){
                                follower_user.id = user.id
                                follower_user.name = user.name
                                follower_user.username = user.username
                                follower_user.avatar = user.avatar
                                follower_user.motives = user.motives
                                follower_user.followers = user.followers
                                
                                appDelegate.array_Follower_Users.append(follower_user)
                            }
                        }
                    }
                    
                    self.uploadCommentToFirebase()
                    
                    //sort
                    if (appDelegate.array_Following_Users.count > 0){
                        for i in (0..<appDelegate.array_Following_Users.count-1){
                            var user: Follow_User = appDelegate.array_Following_Users[i]
                            for j in (i..<appDelegate.array_Following_Users.count){
                                let user_compare: Follow_User = appDelegate.array_Following_Users[j]
                                
                                if (user.username.compare(user_compare.username) == .orderedAscending){
                                    
                                }else if (user.username.compare(user_compare.username) == .orderedDescending){
                                    appDelegate.array_Following_Users.remove(at: i)
                                    appDelegate.array_Following_Users.insert(user_compare, at: i)
                                    
                                    appDelegate.array_Following_Users.remove(at: j)
                                    appDelegate.array_Following_Users.insert(user, at: j)
                                    
                                    user = user_compare
                                }
                            }
                        }
                    }
                    
                    if (appDelegate.array_Follower_Users.count > 0){
                        for i in (0..<appDelegate.array_Follower_Users.count-1){
                            var user: Follow_User = appDelegate.array_Follower_Users[i]
                            for j in (i..<appDelegate.array_Follower_Users.count){
                                let user_compare: Follow_User = appDelegate.array_Follower_Users[j]
                                
                                if (user.username.compare(user_compare.username) == .orderedAscending){
                                    
                                }else if (user.username.compare(user_compare.username) == .orderedDescending){
                                    appDelegate.array_Follower_Users.remove(at: i)
                                    appDelegate.array_Follower_Users.insert(user_compare, at: i)
                                    
                                    appDelegate.array_Follower_Users.remove(at: j)
                                    appDelegate.array_Follower_Users.insert(user, at: j)
                                    
                                    user = user_compare
                                }
                            }
                        }
                    }
                    
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
        }
    }
    
    /*
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    
                    comment.motiff_user = Int(USER.id)!
                    comment.user_id = Int(USER.id)!
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
    */
}

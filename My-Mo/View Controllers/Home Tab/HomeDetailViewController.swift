//
//  HomeDetailViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/5/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import MediaPlayer
import AVKit
import ROThumbnailGenerator

class HomeDetailViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource, UITextViewDelegate, HomeDetailTBCellDelegate{

    @IBOutlet weak var view_Image: UIView!
    @IBOutlet weak var img_Uploaded: UIImageView!
    @IBOutlet weak var img_Shadow: UIImageView!
    @IBOutlet weak var btn_PlayVideo: UIButton!
    
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var btn_Back: UIButton!
    
    @IBOutlet weak var view_Title: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Likes: UILabel!
    
    @IBOutlet weak var view_Messages: UIView!
    @IBOutlet weak var tbl_CommentsList: UITableView!
    
    @IBOutlet weak var view_Comment: UIView!
    @IBOutlet weak var txt_Comment: UITextView!
    @IBOutlet weak var btn_Send_Comment: UIButton!
    

    var loadingNotification:MBProgressHUD? = nil
    var array_Comments: [Comment] = []
    var swipeArray:[Int] = []
    var motiff: Home_Motiff = Home_Motiff()
    var comment_Flag: Int = 0
    var bScreenUp: Int = 0
    var workingIndexPath: IndexPath? = nil
    
    var thumbnail_image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        
        loadCommentsFromServer()
    }

    func setLayout(){
        if (motiff.motiff_id != 0){
            if (motiff.thumbnail.contains("mov")){
                btn_PlayVideo.isHidden = false
                img_Uploaded.image = UIImage(named: "Video_PlaceHolder.png")
                
                if (thumbnail_image == nil){
                    img_Uploaded.image = ROThumbnail.sharedInstance.getThumbnail(URL(string: motiff.thumbnail)!)
                }else{
                    img_Uploaded.image = thumbnail_image
                }
            }else{
                btn_PlayVideo.isHidden = true
                img_Uploaded.sd_setImage(with: URL(string: motiff.thumbnail), placeholderImage: UIImage(named: "Placeholder_Motiff.png"))
            }
            
            lbl_Title.text = motiff.title
            lbl_Likes.text = String(motiff.likes)
        }
        
        view_Comment.isHidden = true
        btn_Send_Comment.layer.cornerRadius = 2.0
        btn_Send_Comment.layer.masksToBounds = true
        
        tbl_CommentsList.separatorStyle = .none
    }
    
    //MARK: - loadCommentsFromServer
    func loadCommentsFromServer(){
  
        
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.label.text = "Loading..."
        
        let parameters = ["motiff_id":motiff.motiff_id]
        Alamofire.request(kApi_GetComments, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.fetchCommentsDataFromJSON(json: jsonObject["data"])
                    self.tbl_CommentsList.reloadData()
                    
                }else{
                    self.array_Comments = []
                    self.swipeArray = []
                    self.tbl_CommentsList.reloadData()

                    
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
    
    //MARK: - Buttons' Events
    @IBAction func click_btn_Back(_ sender: AnyObject) {
        txt_Comment.resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_btn_Comment(_ sender: Any) {
        if (comment_Flag == 0){
            comment_Flag = 1
            UIView.animate(withDuration: 0.3, animations: {
                self.view_Comment.isHidden = false
                self.view_Comment.alpha = 1
            })
        }else{
            comment_Flag = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view_Comment.isHidden = true
                self.view_Comment.alpha = 0
            })
        }
    }
        
    @IBAction func click_btn_SendComment(_ sender: Any) {
        if (txt_Comment.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterComment, OKButton: kOkButton, CancelButton: "", viewController: self)
            return
        }
        
        sendCommentToServer()
    }
    
    func sendCommentToServer(){
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.label.text = "Sending..."
        
        let parameters = ["user_id":USER.id, "motiff_id":motiff.motiff_id, "comment":txt_Comment.text] as [String : Any]
        Alamofire.request(kApi_AddComment, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    
                    self.comment_Flag = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view_Comment.isHidden = true
                        self.view_Comment.alpha = 0
                    })
                    
                    self.loadCommentsFromServer()
                    
                    self.txt_Comment.text = ""
                    
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: kErrorComment, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }
    
    @IBAction func click_btn_PlayVideo(_ sender: Any) {
        let videoURL = URL(string: motiff.thumbnail)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (bScreenUp == 0){
            bScreenUp = 1
            animateViewMoving(up: true, moveValue: 207)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (bScreenUp == 1){
            bScreenUp = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.hideKeyboard()
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        txt_Comment.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txt_Comment.resignFirstResponder()
    }
    
    func hideKeyboard(){
        animateViewMoving(up: false, moveValue: 207)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view_Title.frame = self.view_Title.frame.offsetBy(dx: 0,  dy: movement)
        self.view_Comment.frame = self.view_Comment.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
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
        let cell:HomeDetailTBCell = self.tbl_CommentsList.dequeueReusableCell(withIdentifier: "HomeDetailCell") as! HomeDetailTBCell
        cell.cellDelegate = self
        
        let comment: Comment = array_Comments[indexPath.row]
        
        cell.img_Avatar.sd_setImage(with: URL(string: comment.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        cell.lbl_Name.text = comment.username
        cell.lbl_Comment.text = comment.comment

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
            cell.view_Swipe.frame.origin.x = -60
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func pressedLikesButton(sender: UIButton){
        print(sender.tag)
    }
    
    //MARK: - Swipe Getures
    func swipeLeftCell(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! HomeDetailTBCell
        let indexPath: IndexPath = self.tbl_CommentsList.indexPath(for: cell)!
        
        if (workingIndexPath != nil){
            
            let preCell: HomeDetailTBCell = tbl_CommentsList.cellForRow(at: workingIndexPath!) as! HomeDetailTBCell
            
            if (swipeArray[(workingIndexPath?.row)!] == 1){
                swipeArray[(workingIndexPath?.row)!] = 0
                
                UIView.animate(withDuration: 0.5, animations: {
                    preCell.view_Swipe.frame = preCell.contentView.frame
                })
            }
        }
        
        workingIndexPath = indexPath
        
        swipeArray[cell.tag] = 1
        
        if (swipeArray[cell.tag] == 1){
            UIView.animate(withDuration: 0.5, animations: {
                cell.view_Swipe.frame.origin.x = -60
            })
            
        }
    }
    
    
    func swipeRightCell(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! HomeDetailTBCell
        let indexPath: IndexPath = self.tbl_CommentsList.indexPath(for: cell)!
        
        workingIndexPath = indexPath
        
        swipeArray[cell.tag] = 0
        
        if (swipeArray[cell.tag] == 0){
            UIView.animate(withDuration: 0.5, animations: {
                cell.view_Swipe.frame = cell.contentView.frame
            })
        }
    }

    //MARK: - HomeDetailTBCellDelegate
    func select_btn_Delete(cell: HomeDetailTBCell) {
        let comment: Comment = array_Comments[cell.tag]
        
        if (comment.user_id != USER.id){
            COMMON.methodForAlert(titleString: kAppName, messageString: kErrorOtherComment, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else{
            deleteCommentFromServer(comment: comment)
        }
    }
    
    func deleteCommentFromServer(comment: Comment){
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.label.text = "Deleting..."
        
        let parameters = ["user_id":USER.id, "comment_id":comment.comment_id] as [String : Any]
        Alamofire.request(kApi_DeleteComment, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    
                    self.loadCommentsFromServer()
                    
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: kErrorComment, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

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

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CommentsTBCellDelegate{
    
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
    var loadingNotification:MBProgressHUD? = nil
    
    var motiff_id:Int = 0
    var array_Comments: [Comment] = []
    var swipeArray:[Int] = []
    var workingIndexPath: IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if (motiff_id != 0){
            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.mode = MBProgressHUDMode.indeterminate
            loadingNotification?.label.text = "Loading..."
            
            loadCommentsFromServer()
        }
    }

    //MARK: - loadCommentsFromServer
    func loadCommentsFromServer(){
        
        let parameters = ["motiff_id":motiff_id]
        Alamofire.request(kApi_GetComments, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            self.loadingNotification?.hide(animated: true)
            
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

    // MARK: - Buttons' Event
    @IBAction func click_btn_Back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
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

        if (workingIndexPath != nil){
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
        
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.label.text = "Loading..."
        
        let parameters = ["user_id": USER.id, "followee": comment.user_id]
        Alamofire.request(KApi_JoinFriends, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            self.loadingNotification?.hide(animated: true)
            
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

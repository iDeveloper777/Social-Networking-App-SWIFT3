//
//  HistoryViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/7/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import AVFoundation
import MediaPlayer
import AVKit
import ROThumbnailGenerator


class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, HostHistoryTBCellDelegate{
    
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var txt_Search: UITextField!
    
    @IBOutlet weak var view_Title: UIView!
    @IBOutlet weak var view_Contents: UIView!
    @IBOutlet weak var view_Table: UIView!
    
    @IBOutlet weak var view_Comments: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
    //Local Variables
    var loadingNotification:MBProgressHUD? = nil
    var array_Filter_Hosts:[Host] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        array_Filter_Hosts = []
        
        let notificationName = Notification.Name(kNoti_Refresh_Host_History)
        NotificationCenter.default.addObserver(self, selector: #selector(loadHostsFromServer), name: notificationName, object: nil)
        
//        loadHostsFromServer(repostFlag: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (appDelegate.array_Hosts.count == 0){
            loadHostsFromServer(repostFlag: 0)
        }
    }
    
    func loadHostsFromServer(repostFlag: Int){
        tbl_List.setContentOffset(CGPoint.zero, animated: true)
        if (appDelegate.array_Hosts.count == 0){
            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.mode = MBProgressHUDMode.indeterminate
            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id":USER.id]
        Alamofire.request(kApi_HostHistory, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            if (appDelegate.array_Hosts.count == 0){
                self.loadingNotification?.hide(animated: true)
            }
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    if (repostFlag == 0){
                        self.fetchHostsFromJSON(json: jsonObject["data"])
                    }else{
                        self.fetchFirstHostFromJSON(json: jsonObject["data"])
                    }
                    
                    self.tbl_List.reloadData()
                }else{
                    //                    COMMON.methodForAlert(titleString: kAppName, messageString: kErrorComment, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }

    }
    
    func fetchHostsFromJSON(json: SwiftyJSON.JSON){
        appDelegate.array_Hosts = []
        array_Filter_Hosts = []
        
        for i in (0..<json.count) {
            let host = Host()
            
            host.initHostDataWithJSON(json: json[i])
            appDelegate.array_Hosts.append(host)
            array_Filter_Hosts.append(host)
        }
    }
    
    func fetchFirstHostFromJSON(json: SwiftyJSON.JSON){
        let host = Host()
            
        host.initHostDataWithJSON(json: json[0])
        appDelegate.array_Hosts.insert(host, at: 0)
        array_Filter_Hosts.insert(host, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let host: Host = array_Filter_Hosts[indexPath.row]
        
        if (host.total_comments == 0){
            return CGFloat(kHistoryContentsHeight)
        }else if (host.total_comments == 1){
            return CGFloat(kHistoryContentsHeight + kHistoryCommentHeight)
        }else if (host.total_comments >= 2){
            return CGFloat(kHistoryContentsHeight + kHistoryCommentHeight * 2)
        }
        
        return CGFloat(kHistoryContentsHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_Filter_Hosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HostHistoryTBCell = self.tbl_List.dequeueReusableCell(withIdentifier: "HostHistoryTBCell")! as! HostHistoryTBCell
        cell.cellDelegate = self
        cell.tag = indexPath.row
        
        let host: Host = array_Filter_Hosts[indexPath.row]
        
        cell.lbl_Title.text = host.title
        cell.lbl_Date.text = host.creation_date + "|" + COMMON.convertTimestamp(aTimeStamp: host.creation_time)
        if (host.thumbnail.contains("mov")){
            cell.btn_PlayVideo.isHidden = false
            cell.img_Motiff.image = UIImage(named: "Video_PlaceHolder.png")
            
            if (host.thumbnail_image == nil){
                cell.img_Motiff.image = ROThumbnail.sharedInstance.getThumbnail(URL(string: host.thumbnail)!)
                host.thumbnail_image = ROThumbnail.sharedInstance.getThumbnail(URL(string: host.thumbnail)!)
            }else{
                cell.img_Motiff.image = host.thumbnail_image
            }
        }else{
            cell.btn_PlayVideo.isHidden = true
            cell.img_Motiff.sd_setImage(with: URL(string: host.thumbnail), placeholderImage: UIImage(named: "Placeholder_Motiff.png"))
        }
        
        cell.lbl_Like_Numbers.text = String(host.total_likes)
        cell.lbl_Description.text = host.Description
        
        if (host.avatar1 != ""){
            cell.img_Comment_Avatar01.sd_setImage(with: URL(string: host.avatar1), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        }
        cell.lbl_Comment_Name01.text = host.name1
        cell.lbl_Comment_Text01.text = host.comment1
        
        if (host.avatar2 != ""){
            cell.img_Comment_Avatar02.sd_setImage(with: URL(string: host.avatar2), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        }
        cell.lbl_Comment_Name02.text = host.name2
        cell.lbl_Comment_Text02.text = host.comment2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - Move UIView When Keyboard appear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        refreshTableViewWithSearch()
    }
    
    @IBAction func changedEditingTextbox(_ sender: Any) {
        refreshTableViewWithSearch()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txt_Search.resignFirstResponder()
    }
    
    func refreshTableViewWithSearch() {
        array_Filter_Hosts = []
        
        for i in (0..<appDelegate.array_Hosts.count) {
            let host: Host = appDelegate.array_Hosts[i]
            
            array_Filter_Hosts.append(host)
        }
        
        if (txt_Search.text == ""){
            tbl_List.reloadData()
            return
        }
        
        var k: Int = 0
        while(k < array_Filter_Hosts.count){
            let host: Host = array_Filter_Hosts[k]
            
            let title: String = host.title
            let lowerString: String = title.lowercased()
            let compareLowerString: String = (txt_Search.text?.lowercased())!
            
            if (lowerString.range(of: compareLowerString) == nil){
                array_Filter_Hosts.remove(at: k)
            }else{
                k += 1
            }
        }
        
        tbl_List.reloadData()
    }
    
    //MARK: - HostHistoryTBCellDelegate
    func click_ViewMoreComments_Button(cell: HostHistoryTBCell) {
        let host: Host = array_Filter_Hosts[cell.tag]
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CommentsView") as! CommentsViewController
        viewController.motiff_id = host.id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func click_Likes_Button(cell: HostHistoryTBCell) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LikesView") as! LikesViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func click_Play_Video(cell: HostHistoryTBCell) {
        let host: Host = array_Filter_Hosts[cell.tag]
        
        let videoURL = URL(string: host.thumbnail)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func click_More_Button(cell: HostHistoryTBCell) {
        showMoreMenu(cell: cell)
    }
    
    func showMoreMenu(cell: HostHistoryTBCell){
        let alertController = UIAlertController(title: "My-Mo", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        
        let repostAction = UIAlertAction(title: "Repost Motiff", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Repost Motiff")
            
            self.repostMotiff(cell: cell)
        }
        
        let deleteLibraryAction = UIAlertAction(title: "Delete Motiff", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Delete Motiff")
            
            self.deleteMotiff(cell: cell)
        }
        
        let mapoffLibraryAction = UIAlertAction(title: "Map Search Off", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Map Search Off")
            
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(repostAction)
        alertController.addAction(deleteLibraryAction)
        alertController.addAction(mapoffLibraryAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - API Calls
    func repostMotiff(cell: HostHistoryTBCell){
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.label.text = "Loading..."

        let host: Host = array_Filter_Hosts[cell.tag]
        let parameters = ["motive_id":host.id]
        Alamofire.request(kApi_RepostMotiff, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.tbl_List.setContentOffset(CGPoint.zero, animated: true)
                    
                    self.loadHostsFromServer(repostFlag: 1)
                    
                    self.tbl_List.reloadData()
                }else{
                    //                    COMMON.methodForAlert(titleString: kAppName, messageString: kErrorComment, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }
    
    func deleteMotiff(cell: HostHistoryTBCell){
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.label.text = "Loading..."
        
        let host: Host = array_Filter_Hosts[cell.tag]
        let parameters = ["motive_id":host.id]
        Alamofire.request(kApi_DeleteMotiff, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.deleteMotiffInArray(motiff_id: host.id)
                    self.array_Filter_Hosts.remove(at: cell.tag)
                    
                    self.tbl_List.reloadData()
                }else{
                    //                    COMMON.methodForAlert(titleString: kAppName, messageString: kErrorComment, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }

    }
    
    func deleteMotiffInArray(motiff_id: Int){
        var nIndex: Int = -1
        
        for i in (0..<appDelegate.array_Hosts.count){
            let host: Host = appDelegate.array_Hosts[i]
            
            if (host.id == motiff_id){
                nIndex = i
            }
        }
        
        if (nIndex != -1){
            appDelegate.array_Hosts.remove(at: nIndex)
        }
    }
}

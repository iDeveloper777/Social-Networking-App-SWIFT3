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
import Firebase

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
    var refresh_Flag: Int = 0
    
//    var loadingNotification:MBProgressHUD? = nil
    let refreshControl: UIRefreshControl = UIRefreshControl()
//    let refreshControl: PetRefreshControl = PetRefreshControl()
    
    var array_Filter_Hosts:[Host] = []
    
    //MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        array_Filter_Hosts = []
        
        let notificationName = Notification.Name(kNoti_Refresh_Host_History)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAllDatas), name: notificationName, object: nil)
        
//        loadHostsFromServer(repostFlag: 0)
        
        if (appDelegate.array_Hosts.count == 0){
            loadHostsFromFirebase()
//            loadHostsFromServer(repostFlag: 0)
        }else {
//            self.loadingNotification?.hide(animated: true)
        }
        
        setLayout()
    }
    
    func setLayout(){
        refreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
        tbl_List.addSubview(refreshControl)
        
//        refreshControl.tintColor = UIColor.clear
//        refreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
//        tbl_List.addSubview(refreshControl)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        if (host.content_width != "" && host.content_height != ""){
            var height: CGFloat = 0
            
            height = CGFloat((host.content_height as NSString).floatValue) / CGFloat((host.content_width as NSString).floatValue) * (Main_Screen_Width - 17)
            height = height + CGFloat(kHistoryContentsHeight) - CGFloat(kHistoryImageHeight)
            return height
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
        cell.lbl_Date.text = COMMON.get_Date_from_UTC_time(string: host.creation_date + " " + host.creation_time) + " | " + COMMON.get_Time_from_UTC_time(string: host.creation_date + " " + host.creation_time)
        cell.lbl_Like_Numbers.text = String(host.likes_count)
        cell.lbl_Description.text = host.Description
        
        if (host.content_width != "" && host.content_height != ""){
            let height: CGFloat = CGFloat((host.content_height as NSString).floatValue) / CGFloat((host.content_width as NSString).floatValue) * (Main_Screen_Width - 17)
            let frame: CGRect = CGRect(x: 8, y: 51, width: self.tbl_List.bounds.size.width - 17, height: height)
            
//            let str: String = String(describing: frame.width) + " - " + String(describing: frame.height)
//            print(str)
            
            cell.img_Motiff.frame = frame
            cell.img_Motiff.sd_setImage(with: URL(string: host.thumbnail_url), placeholderImage: UIImage(named: "Placeholder_Motiff_History.png"))
        }
        
        if (host.isVideo == 1){
            cell.btn_PlayVideo.isHidden = false
            cell.btn_PlayVideo.center = cell.img_Motiff.center
        }else{
            cell.btn_PlayVideo.isHidden = true
        }
        
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
        let indexPath: IndexPath = tbl_List.indexPath(for: cell)!
        let host: Host = array_Filter_Hosts[cell.tag]
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CommentsView") as! CommentsViewController
        viewController.host = array_Filter_Hosts[indexPath.row]
        viewController.motiff_id = host.id
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func click_Likes_Button(cell: HostHistoryTBCell) {
        let indexPath: IndexPath = tbl_List.indexPath(for: cell)!
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LikesView") as! LikesViewController
        viewController.host = array_Filter_Hosts[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func click_Play_Video(cell: HostHistoryTBCell) {
        let host: Host = array_Filter_Hosts[cell.tag]
        
        let videoURL = URL(string: host.content_url)
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
            
//            self.repostMotiff(cell: cell)
            self.repostMotiffWithFirebase(cell: cell)
        }
    
        let deleteLibraryAction = UIAlertAction(title: "Delete Motiff", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Delete Motiff")
            
//            self.deleteMotiff(cell: cell)
            self.deleteMotiffWithFirebase(cell: cell)
        }
        
        let mapoffLibraryAction = UIAlertAction(title: "Map Search Off", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Map Search Off")
            
            self.MapSearchOffMotiffWithFirebase(cell: cell)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(repostAction)
        alertController.addAction(deleteLibraryAction)
        alertController.addAction(mapoffLibraryAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Firebase
    func refreshAllDatas(){
        if (appDelegate.latest_Host != nil){
            _ = self.navigationController?.popViewController(animated: true)
            
            appDelegate.array_Hosts.insert(appDelegate.latest_Host!, at: 0)
            array_Filter_Hosts.insert(appDelegate.latest_Host!, at: 0)
            
            tbl_List.reloadData()
            tbl_List.setContentOffset(CGPoint.zero, animated: true)
            
            appDelegate.latest_Host = nil
        }
        
        refresh_Flag = 1
//        refreshControl.beginRefreshing()
        
        loadHostsFromFirebase()
    }
    
    func loadHostsFromFirebase(){
        tbl_List.setContentOffset(CGPoint.zero, animated: true)
        
        if (appDelegate.array_Hosts.count == 0 || refresh_Flag == 1){
            FirebaseModule.shareInstance.get_Motiffs(user_id: USER.id)
                { (response: NSArray?, error: Error?) in
                    if (error == nil){
                        appDelegate.array_Hosts = []
                        self.array_Filter_Hosts = []
                        
                        appDelegate.array_Hosts = response as! [Host]
                        self.array_Filter_Hosts = response as! [Host]
                        
                        self.tbl_List.reloadData()
                        
                        self.refresh_Flag = 0
                        self.refreshControl.endRefreshing()
                    }else{
                        COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                        
                        self.refresh_Flag = 0
                        self.refreshControl.endRefreshing()
                    }
            }
        }
    }
    
    func repostMotiffWithFirebase(cell: HostHistoryTBCell){
        
        let host: Host = array_Filter_Hosts[cell.tag]
        host.id = USER.id + " " + COMMON.get_Current_UTC_Date_Time()
        
        FirebaseModule.shareInstance.upload_Motiff(host: host){
            (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                appDelegate.array_Hosts.insert(host, at: 0)
                self.array_Filter_Hosts.insert(host, at: 0)
                self.tbl_List.reloadData()
                self.tbl_List.setContentOffset(CGPoint.zero, animated: true)
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }

    }
    
    func deleteMotiffWithFirebase(cell: HostHistoryTBCell){
        
        let host: Host = array_Filter_Hosts[cell.tag]
        
        FirebaseModule.shareInstance.delete_Motiff(host: host){
            (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                
                for i in (0..<appDelegate.array_Hosts.count){
                    let host_com: Host = appDelegate.array_Hosts[i]
                    
                    if (host_com.id == host.id){
                        appDelegate.array_Hosts.remove(at: cell.tag)
                        break
                    }
                }
                self.array_Filter_Hosts.remove(at: cell.tag)
                
                self.tbl_List.reloadData()
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
        
    }

    func MapSearchOffMotiffWithFirebase(cell: HostHistoryTBCell){
        
        let host: Host = array_Filter_Hosts[cell.tag]
        host.mapsearch = 0
        
        FirebaseModule.shareInstance.update_Motiff_Map_Search(host: host){
            (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                self.array_Filter_Hosts.remove(at: cell.tag)
                self.array_Filter_Hosts.insert(host, at: cell.tag)
                
                for i in (0..<appDelegate.array_Hosts.count){
                    let host_com: Host = appDelegate.array_Hosts[i]
                    
                    if (host_com.id == host.id){
                        appDelegate.array_Hosts.remove(at: cell.tag)
                        appDelegate.array_Hosts.insert(host, at: cell.tag)
                        break
                    }
                }
                
                self.tbl_List.reloadData()
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
        
    }
    
    /*
    // MARK: - API Calls
    func loadHostsFromServer(repostFlag: Int){
        tbl_List.setContentOffset(CGPoint.zero, animated: true)
        if (appDelegate.array_Hosts.count == 0){
            //            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            //            loadingNotification?.mode = MBProgressHUDMode.indeterminate
            //            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id":USER.id]
        Alamofire.request(kApi_HostHistory, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            if (appDelegate.array_Hosts.count == 0){
                //                self.loadingNotification?.hide(animated: true)
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
            
            //            host.initHostDataWithJSON(json: json[i])
            appDelegate.array_Hosts.append(host)
            array_Filter_Hosts.append(host)
        }
    }
    
    func fetchFirstHostFromJSON(json: SwiftyJSON.JSON){
        let host = Host()
        
        //        host.initHostDataWithJSON(json: json[0])
        appDelegate.array_Hosts.insert(host, at: 0)
        array_Filter_Hosts.insert(host, at: 0)
    }
    
    func repostMotiff(cell: HostHistoryTBCell){
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading..."

        let host: Host = array_Filter_Hosts[cell.tag]
        let parameters = ["motive_id":host.id]
        Alamofire.request(kApi_RepostMotiff, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
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
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading..."
        
        let host: Host = array_Filter_Hosts[cell.tag]
        let parameters = ["motive_id":host.id]
        Alamofire.request(kApi_DeleteMotiff, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.deleteMotiffInArray(motiff_id: host.id)
                    self.array_Filter_Hosts.remove(at: cell.tag)
                    
                    self.tbl_List.reloadData()
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
    
    func deleteMotiffInArray(motiff_id: String){
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
 */
}

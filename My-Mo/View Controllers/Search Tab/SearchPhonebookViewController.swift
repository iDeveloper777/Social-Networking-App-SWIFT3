//
//  SearchPhonebookViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/14/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

import Alamofire
import SwiftyJSON
import MBProgressHUD

class SearchPhonebookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PhoneBookTBCell01Delegate, PhoneBookTBCell02Delegate, MFMessageComposeViewControllerDelegate{
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Title: UIView!
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    @IBOutlet weak var view_Characters: UIView!

//    var loadingNotification:MBProgressHUD? = nil
    
    var strSectionArray:[String] = ["MO'S IS MY PHONEBOOK", "INVITE TO MY-MO"]
    var strAlphaBetics:[String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var y_Button = 0

    var array_ContactList: [PhoneContact_User] = []
    var array_ContactList_Filter: [PhoneContact_User] = []
    var array_PhoneBookUsers: [PhoneBook_User] = []
    var array_PhoneBookUsers_Filter: [PhoneBook_User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initAlphaBetics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        array_ContactList = []
        array_ContactList_Filter = []
        array_PhoneBookUsers = []
        array_PhoneBookUsers_Filter = []
        
        getContactList()
        loadPhoneBookUsersFromServer()
    }
    
    func getContactList(){
        
        let contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactGivenNameKey,
                CNContactMiddleNameKey,
                CNContactFamilyNameKey,
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            return results
        }()

        if (contacts.count == 0){
            return
        }
        
        for i in (0..<contacts.count){
            let cont: CNContact = contacts[i]
            
            let cnPhone: CNPhoneNumber = cont.phoneNumbers[0].value
            let phone: String = cnPhone.value(forKey: "digits") as! String
            
            let pc_user = PhoneContact_User()
            pc_user.mobile = phone
            pc_user.username = cont.givenName + " " + cont.middleName + " "
            
            array_ContactList.append(pc_user)
        }
        
        //sort
        for i in (0..<array_ContactList.count-1){
            var pc_user: PhoneContact_User = array_ContactList[i]
            for j in (i..<array_ContactList.count){
                let pc_user_compare: PhoneContact_User = array_ContactList[j]
                
                if (pc_user.username.compare(pc_user_compare.username) == .orderedAscending){
                    
                }else if (pc_user.username.compare(pc_user_compare.username) == .orderedDescending){
                    array_ContactList.remove(at: i)
                    array_ContactList.insert(pc_user_compare, at: i)
                    
                    array_ContactList.remove(at: j)
                    array_ContactList.insert(pc_user, at: j)
                    
                    pc_user = pc_user_compare
                }
                
            }
        }
        
        for i in (0..<array_ContactList.count){
            let pc_user: PhoneContact_User = array_ContactList[i]
            array_ContactList_Filter.append(pc_user)
        }

    }
    
    //MARK: - loadPhoneBookUsersFromServer
    func loadPhoneBookUsersFromServer(){
        if (array_PhoneBookUsers.count == 0){
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id": USER.id, "device": "ios"] as [String : Any]
        Alamofire.request(kApi_SearchPhoneBook, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.fetchPhoneBookUserDataFromJSON(json: jsonObject["response"])
                    self.tbl_List.reloadData()
                    
                }else{
                    self.array_PhoneBookUsers = []
                    self.array_PhoneBookUsers_Filter = []
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
    
    func fetchPhoneBookUserDataFromJSON(json: SwiftyJSON.JSON){
        array_PhoneBookUsers = []
        
        for i in (0..<json.count) {
            let pb_user = PhoneBook_User()
            
            pb_user.initPhoneBookUserDataWithJSON(json: json[i])
            array_PhoneBookUsers.append(pb_user)
            array_PhoneBookUsers_Filter.append(pb_user)
        }
    }

    
    func initAlphaBetics(){
        var temp_distance = 0
        var tagValue = 1000
        y_Button = Int(COMMON.HEIGHT(view: view_Characters)) / (strAlphaBetics.count + 2)
        temp_distance = y_Button
        
        y_Button = (Int(COMMON.HEIGHT(view: view_Characters)) - (temp_distance * (strAlphaBetics.count + 0)))/2
        
//        let letter_Y = (COMMON.HEIGHT(view: view_Users) - COMMON.HEIGHT(view: scr_Users) - 15) / 2 + COMMON.HEIGHT(view: scr_Users) - 2
        
        //adding A to Z index
        for k in (0..<strAlphaBetics.count) {
            
            let index = UIButton(frame: CGRect(x: 0, y: y_Button, width: 20, height: temp_distance))
            index.setTitle(strAlphaBetics[k], for: .normal)
            index.titleLabel!.font = UIFont.systemFont(ofSize: 12.0)
            index.tag = tagValue
            index.setTitleColor(UIColor.lightGray, for: .normal)
            index.titleLabel!.textAlignment = .center
            index.titleLabel!.adjustsFontSizeToFitWidth = true
            index.addTarget(self, action: #selector(reloading(sender:)), for: .touchUpInside)
            view_Characters.addSubview(index)
            tagValue += 1
            y_Button = y_Button + temp_distance
        }
    }

    func reloading(sender: UIButton) {
        for subview in self.view_Characters.subviews {
            if subview is UIButton {
                let btn_Likes = subview as! UIButton
                btn_Likes.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
        sender.setTitleColor(UIColor.blue, for: .normal)
        
        let charater = self.strAlphaBetics[sender.tag - 1000]
        print(charater)

        array_ContactList_Filter = []
        array_PhoneBookUsers_Filter = []
        for i in (0..<array_ContactList.count){
            let pc_user: PhoneContact_User = array_ContactList[i]
            if (pc_user.username.compare(charater) == .orderedDescending ||
                pc_user.username.compare(charater) == .orderedSame){
                array_ContactList_Filter.append(pc_user)
            }
        }
        
        for i in (0..<array_PhoneBookUsers.count){
            let pb_user: PhoneBook_User = array_PhoneBookUsers[i]
            if (pb_user.username.compare(charater) == .orderedDescending ||
                pb_user.username.compare(charater) == .orderedSame){
                array_PhoneBookUsers_Filter.append(pb_user)
            }
        }
        
        tbl_List.reloadData()
    }
    
    //MARK: - Buttons' Events
    @IBAction func click_btn_Back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    

    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return array_PhoneBookUsers_Filter.count
        }else{
            return array_ContactList_Filter.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        headerView.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.bounds.size.width, height: 40))
        label.font = UIFont.systemFont(ofSize: 15, weight: 0)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.text = strSectionArray[section]
        
        headerView.addSubview(label)
        
        return headerView
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:UITableViewCell = self.tbl_List.dequeueReusableCell(withIdentifier: "SearchPhonebookCell01")! as UITableViewCell
        
        if (indexPath.section == 0){
            let cell01 = self.tbl_List.dequeueReusableCell(withIdentifier: "SearchPhonebookCell01")! as! PhoneBookTBCell01
            cell01.cellDelegate = self
            let pb_user: PhoneBook_User = array_PhoneBookUsers_Filter[indexPath.row]
            
            cell01.img_Avatar.sd_setImage(with: URL(string: pb_user.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
            if (pb_user.avatar == ""){
                cell01.img_Avatar.backgroundColor = UIColor(red: 238/255, green: 125/255, blue: 49/255, alpha: 1.0)
                let index = pb_user.username.index(pb_user.username.startIndex, offsetBy: 1)
                cell01.lbl_Character.text = pb_user.username.substring(to: index).uppercased()
            }else{
                cell01.img_Avatar.sd_setImage(with: URL(string: pb_user.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
                cell01.lbl_Character.text = ""
            }
            
            cell01.lbl_Title.text = pb_user.username
            
            return cell01
        }else{
            let cell02 = self.tbl_List.dequeueReusableCell(withIdentifier: "SearchPhonebookCell02")! as! PhoneBookTBCell02
            cell02.cellDelegate = self
            let pc_user: PhoneContact_User = array_ContactList_Filter[indexPath.row]
            
            cell02.lbl_Title.text = pc_user.username
            
            return cell02
        }
        
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - PhoneBookTBCell01Delegate
    func select_btn_Follow(cell: PhoneBookTBCell01) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        sendFriendRequest(index: indexPath.row)
    }
    
    //MARK: - PhoneBookTBCell02Delegate
    func select_btn_SMS(cell: PhoneBookTBCell02) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        sendFriendRequestWithMessage(index: indexPath.row)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // MARK: - API Calls
    func sendFriendRequest(index: Int){
        let pb_user: PhoneBook_User = array_PhoneBookUsers_Filter[index]
        
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading..."
        
        let parameters = ["user_id": USER.id, "followee": pb_user.id]
        Alamofire.request(KApi_JoinFriends, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.array_PhoneBookUsers_Filter.remove(at: index)
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
    
    // MARK: - MFMessageComposeViewControllerDelegate
    func sendFriendRequestWithMessage(index: Int){
        let pc_user: PhoneContact_User = array_ContactList_Filter[index]
        
        if MFMessageComposeViewController.canSendText() {
            let recipents: [String] = [pc_user.mobile]
            let message: String? = "Add me on MY-MO! Username : " + pc_user.username + " https://itunes.apple.com/us/app/mymo/id12345678?ls=1&mt=8"
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            messageController.recipients = recipents
            messageController.body = message
            self.present(messageController, animated: true, completion: { _ in })
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result){
        case .cancelled:
            COMMON.methodForAlert(titleString: kAppName, messageString: "Message cancelled succesfully", OKButton: kOkButton, CancelButton: "", viewController: self)
            break
        case .failed:
            COMMON.methodForAlert(titleString: kAppName, messageString: "Failed to send SMS!", OKButton: kOkButton, CancelButton: "", viewController: self)
            break
        case .sent:
            COMMON.methodForAlert(titleString: kAppName, messageString: "Message sent succesfully", OKButton: kOkButton, CancelButton: "", viewController: self)
            break
//        default:
//            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }

}

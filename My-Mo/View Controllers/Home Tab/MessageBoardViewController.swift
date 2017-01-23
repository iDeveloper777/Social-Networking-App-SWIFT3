//
//  MessageBoardViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/10/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

class MessageBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    

    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var img_Avatar: UIImageView!
    
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Title: UIView!
    @IBOutlet weak var lbl_UserName: UILabel!
    
    @IBOutlet weak var view_ChatBoard: UIView!
    @IBOutlet weak var view_InputBoard: UIView!
    @IBOutlet weak var tv_Message: NonPasteUitextField!
    @IBOutlet weak var btn_SendMessage: UIButton!
    

    @IBOutlet weak var tbl_Messages: UITableView!
    
//    var tbl_Messages: UITableView!
    var messagesArray = [String]()
//    var messagesArray:[Any]
    var dictChat = [AnyHashable: Any]()
    var convertedString:String = ""
    var keyboardHeight:CGFloat = 216
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }
    
    func setLayout(){
        img_Avatar?.image = UIImage.init(named: "Home_img_Sample.png")
        img_Avatar?.layer.cornerRadius = (img_Avatar?.frame.size.height)! / 2
        img_Avatar?.layer.masksToBounds = true
        img_Avatar?.layer.borderWidth = 1
        img_Avatar?.layer.borderColor = UIColor.gray.cgColor
        

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        methodGetPM()
        methodAddMessgeTable()
    }

    func methodAddMessgeTable(){
//        tbl_Messages.isHidden = true
//        tbl_Messages = UITableView(frame: CGRect(x: 10, y: 3, width: COMMON.WIDTH(view: view_ChatBoard)-20, height: COMMON.HEIGHT(view: view_ChatBoard)-50), style: .grouped) //+40 y adn H
//        
//        tbl_Messages.delegate = self
//        tbl_Messages.dataSource = self
//        tbl_Messages.backgroundColor = UIColor.clear
//        tbl_Messages.separatorColor = UIColor.clear
//        tbl_Messages.showsVerticalScrollIndicator = false
//        view_ChatBoard.addSubview(tbl_Messages)
        self.perform(#selector(goToBottom), with: nil, afterDelay: 0.0)
    }
    
    func goToBottom(){
        let lastSectionIndex = max(0, tbl_Messages.numberOfSections - 1)
        let lastRowIndex = max(0, tbl_Messages.numberOfRows(inSection: lastSectionIndex) - 1)
        let lastIndexPath = NSIndexPath(row: lastRowIndex, section: lastSectionIndex) as IndexPath
        
        tbl_Messages.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
    }
    
    // MARK: - Buttons' Event
    @IBAction func click_btn_Back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func click_btn_SendMessage(_ sender: AnyObject) {
        let rawString = self.tv_Message.text
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        let trimmed = (rawString?.trimmingCharacters(in: whitespace))! as String
        if (trimmed.characters.count > 0){
            self.SendPM()
            self.messagesArray.append(trimmed)
            
//            UIView.animate(withDuration: 0.1, animations: {
                self.tbl_Messages.beginUpdates()
                let IndexPathOfLastRow = IndexPath(row: self.messagesArray.count - 1, section: 0) as IndexPath
                self.tbl_Messages.insertRows(at: [IndexPathOfLastRow], with: UITableViewRowAnimation.right)
                self.tbl_Messages.endUpdates()
//            })
            
            self.tv_Message.text = ""
            
        }
        
        goToBottom()
    }
    
    
    
    func SendPM(){
        
    }
    
    //fetching conversation
    func methodGetPM(){
        let arr:[Any] = ["",""]
        dataRetrieved(withData: arr)
    }
    
    func dataRetrieved(withData data: Any) {
        dictChat = ["message": "Toronto Pearson"]
        messagesArray.append("Hi")
        messagesArray.append("Where are you guy")
        messagesArray.append("How are you!")
        messagesArray.append("about to leave the house")
    }

    
    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
//        return dictChat.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        convertedString = messagesArray[indexPath.section] as String
        
        //NSLog(@"print section %ld print row %ld and print message %@",(long)indexPath.section,(long)indexPath.row,convertedString);
        let text = convertedString as String
        let labelFont = UIFont.systemFont(ofSize: 12)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attrDict = [
            NSFontAttributeName : labelFont,
            NSParagraphStyleAttributeName : paragraphStyle
        ] as [String : Any]
        

        //assume your maximumSize contains {255, MAXFLOAT}
        
        let lblRect = NSString(string: text).boundingRect(with: CGSize(width: self.view_InputBoard.frame.size.width - 10, height: 999), options: .usesLineFragmentOrigin, attributes: attrDict, context: nil)
        let size = lblRect.size
        return size.height + 30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header = view as! UITableViewHeaderFooterView
//        
//        if let textLabel = header.textLabel{
//            textLabel.font = UIFont.boldSystemFont(ofSize: 10)
//            textLabel.textAlignment = .center
//        }
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        var sectionName = ""
//        sectionName = "Monday"
//        
//        return sectionName
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        if (section == 0) {
            headerView.backgroundColor = UIColor.clear
        } else {
            headerView.backgroundColor = UIColor.clear
        }

        let label = UILabel(frame: CGRect(x: (self.view.bounds.size.width - 200)/2, y: 0, width: 200, height: 22))
        label.text = "Monday"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier:String = "MessageCell"
        let cell:UITableViewCell = tbl_Messages.dequeueReusableCell(withIdentifier: CellIdentifier)! as UITableViewCell
        
        let frame:CGRect = tableView.rectForRow(at: indexPath)
        
        //username settings
        let labelName = UILabel()
        labelName.frame = CGRect(x: 0, y: 0, width: tbl_Messages.frame.size.width, height: 10)
        labelName.backgroundColor = UIColor.white
        labelName.font = UIFont(name: "Helvetica", size: 10)
        if (indexPath.row >= 2){
            labelName.textColor = UIColor.orange
            labelName.text = "ME"
        }
        else {
            labelName.textColor = UIColor.red
            labelName.text = "CHHAVI"
        }
        
        //Message settings
        var message = cell.viewWithTag(100) as? UILabel
        
        if message == nil {
            message = UILabel()
           
        }
        
        if (indexPath.row >= 2) {
            message?.frame = CGRect(x: 160, y: 4, width: tbl_Messages.frame.size.width - 170, height: frame.size.height - 8)
        }
        else {
            message?.frame = CGRect(x: 10, y: 4, width: tbl_Messages.frame.size.width - 170, height: frame.size.height - 8)
        }
        
        message?.textColor = UIColor.black
        message?.numberOfLines = 10
        message?.font = UIFont(name: "Helvetica", size: 12)
        message?.tag = 100
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 10.0
        paragraphStyle.firstLineHeadIndent = 10.0
        paragraphStyle.tailIndent = -30.0
        let attrsDictionary = [NSParagraphStyleAttributeName: paragraphStyle]
        message?.attributedText = NSAttributedString(string: messagesArray[indexPath.row], attributes: attrsDictionary)
        message?.textAlignment = .left
        message?.backgroundColor = UIColor(red: 232 / 255.0, green: 232 / 255.0, blue: 232 / 255.0, alpha: 1.0)
        message?.layer.cornerRadius = 16
        message?.layer.borderWidth = 2.0
        message?.clipsToBounds = true
        
        if (indexPath.row >= 2){
            message?.layer.borderColor = UIColor.orange.cgColor
        }else{
            message?.layer.borderColor = UIColor.black.cgColor
        }
        
        cell.contentView.addSubview(message!)
        cell.selectionStyle = .none
        
        //username settings
        let labelLine = UILabel()
        labelLine.frame = CGRect(x: 1, y: 11, width: 2, height: frame.size.height - 11)
        if (indexPath.row >= 2) {
            labelLine.backgroundColor = UIColor.orange
        }
        else {
            labelLine.backgroundColor = UIColor.red
        }
        //        [cell.contentView addSubview:labelLine];
        
        //Time Settings
        var labelTime = cell.viewWithTag(200) as? UILabel
        
        if labelTime == nil {
            labelTime = UILabel()
            cell.contentView.addSubview(labelTime!)
        }

        if (indexPath.row >= 2) {
            labelTime?.frame = CGRect(x: tbl_Messages.frame.size.width - 45, y: frame.size.height / 2 - 5, width: 30, height: 11)
        }
        else {
            labelTime?.frame = CGRect(x: tbl_Messages.frame.size.width - 195, y: frame.size.height / 2 - 5, width: 30, height: 11)
        }
        labelTime?.textAlignment = .center
        labelTime?.font = UIFont(name: "Helvetica", size: 10)
        labelTime?.text = "12:40"
        labelTime?.tag = 200
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        hideKeyboard()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tv_Message.resignFirstResponder()
//        hideKeyboard()
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
        self.tv_Message.resignFirstResponder()
        
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
                                                y: self.view_ChatBoard.frame.size.height - self.view_InputBoard.frame.size.height-self.keyboardHeight,
                                                width: self.view_InputBoard.frame.size.width,
                                                height: self.view_InputBoard.frame.size.height)
            self.tbl_Messages.frame = CGRect(x: self.tbl_Messages.frame.origin.x,
                                             y: self.tbl_Messages.frame.origin.y,
                                             width: self.tbl_Messages.frame.size.width,
                                             height: self.view_ChatBoard.frame.size.height - self.view_InputBoard.frame.size.height-self.keyboardHeight)
            
            }, completion: {(finished: Bool) -> Void in
                self.goToBottom()
        })
    }
    
    func hideKeyboard(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionCrossDissolve, animations: {() -> Void in
            self.view_InputBoard.frame = CGRect(x: self.view_InputBoard.frame.origin.x,
                                                y: self.view_ChatBoard.frame.size.height - self.view_InputBoard.frame.size.height,
                                                width: self.view_InputBoard.frame.size.width,
                                                height: self.view_InputBoard.frame.size.height)
            self.tbl_Messages.frame = CGRect(x: self.tbl_Messages.frame.origin.x,
                                             y: self.tbl_Messages.frame.origin.y,
                                             width: self.tbl_Messages.frame.size.width,
                                             height: self.view_ChatBoard.frame.size.height - self.view_InputBoard.frame.size.height)
            UIApplication.shared.sendAction(#selector(self.resignFirstResponder), to: nil, from: nil, for: nil)
            
            }, completion: {(finished: Bool) -> Void in
                
                
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

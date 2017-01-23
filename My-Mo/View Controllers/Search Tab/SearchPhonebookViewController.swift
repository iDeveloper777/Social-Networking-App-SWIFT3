//
//  SearchPhonebookViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/14/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

class SearchPhonebookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Title: UIView!
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    @IBOutlet weak var view_Characters: UIView!

    var strTitleArray01:[String] = []
    var strTitleArray02:[String] = []
    var strCharacterArray:[String] = []
    var strSectionArray:[String] = []
    var strAlphaBetics:[String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var y_Button = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        initTableTitle()
        initAlphaBetics()
    }
    
    func initTableTitle(){
        strTitleArray01 = ["Dug", "Jen Jen", "Iasie"]
        strTitleArray02 = ["Brice", "Carlon", "Deal", "French", "Jay"]
        
        strCharacterArray = ["D", "J", "I"]
        strSectionArray = ["MO'S IS MY PHONEBOOK", "INVITE TO MY-MO"]
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
        var _: Int
        var startingLetter: String = ""
        switch sender.tag - 1000 {
        case 0:
            startingLetter = "A"
        case 1:
            startingLetter = "B"
        case 2:
            startingLetter = "C"
        case 3:
            startingLetter = "D"
        case 4:
            startingLetter = "E"
        case 5:
            startingLetter = "F"
        case 6:
            startingLetter = "G"
        case 7:
            startingLetter = "H"
        case 8:
            startingLetter = "I"
        case 9:
            startingLetter = "J"
        case 10:
            startingLetter = "K"
        case 11:
            startingLetter = "L"
        case 12:
            startingLetter = "M"
        case 13:
            startingLetter = "N"
        case 14:
            startingLetter = "O"
        case 15:
            startingLetter = "P"
        case 16:
            startingLetter = "Q"
        case 17:
            startingLetter = "R"
        case 18:
            startingLetter = "S"
        case 19:
            startingLetter = "T"
        case 20:
            startingLetter = "U"
        case 21:
            startingLetter = "V"
        case 22:
            startingLetter = "W"
        case 23:
            startingLetter = "X"
        case 24:
            startingLetter = "Y"
        case 25:
            startingLetter = "Z"
        default:
            break
        }
        
        print(startingLetter)
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
            return strTitleArray01.count
        }else{
            return strTitleArray02.count
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
        var cell:UITableViewCell = self.tbl_List.dequeueReusableCell(withIdentifier: "SearchPhonebookCell01")! as UITableViewCell
        
        if (indexPath.section == 0){
            cell = self.tbl_List.dequeueReusableCell(withIdentifier: "SearchPhonebookCell01")! as UITableViewCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none

            let img_Avatar = cell.viewWithTag(100) as? UIImageView
//            img_Avatar?.image = UIImage.init(named: strImageArray[indexPath.row])
            img_Avatar?.layer.cornerRadius = (img_Avatar?.frame.size.height)! / 2
            img_Avatar?.layer.masksToBounds = true
            img_Avatar?.layer.borderWidth = 0
            img_Avatar?.layer.borderColor = UIColor.gray.cgColor
            
            let lbl_Title = cell.viewWithTag(300) as? UILabel
            lbl_Title?.text = strTitleArray01[indexPath.row]
            
            let lbl_Character = cell.viewWithTag(200) as? UILabel
            lbl_Character?.text = strCharacterArray[indexPath.row]
        }else{
            cell = self.tbl_List.dequeueReusableCell(withIdentifier: "SearchPhonebookCell02")! as UITableViewCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let lbl_Title = cell.viewWithTag(300) as? UILabel
            lbl_Title?.text = strTitleArray02[indexPath.row]
        }
        
        
        var btn_Likes: UIButton! = nil
        for subview in cell.contentView.subviews {
            if subview is UIButton {
                btn_Likes = subview as! UIButton
                
                btn_Likes?.addTarget(self, action: #selector(pressedLikesButton), for: .touchUpInside)
                btn_Likes?.tag = 10000 + indexPath.row
                btn_Likes.frame = CGRect(x: COMMON.X(view: btn_Likes),
                                         y: COMMON.Y(view: btn_Likes),
                                         width: COMMON.HEIGHT(view: btn_Likes),
                                         height: COMMON.HEIGHT(view: btn_Likes))
                
                break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func pressedLikesButton(sender: UIButton){
        print(sender.tag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//
//  NotificationViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/7/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var view_Navigation: UIView!
    
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Segments: UIView!
    @IBOutlet weak var lbl_SegNumber01: UILabel!
    @IBOutlet weak var lbl_SegTitle01: UILabel!
    @IBOutlet weak var lbl_SegUnderLine01: UILabel!
    @IBOutlet weak var lbl_SegNumber02: UILabel!
    @IBOutlet weak var lbl_SegTitle02: UILabel!
    @IBOutlet weak var lbl_SegUnderLine02: UILabel!
    @IBOutlet weak var lbl_SegNumber03: UILabel!
    @IBOutlet weak var lbl_SegTitle03: UILabel!
    @IBOutlet weak var lbl_SegUnderLine03: UILabel!
    
    @IBOutlet weak var lbl_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
    
    var nSegIndex:Int = 0
    var selected_Color = UIColor(red: 245/255, green: 116/255, blue: 44/255, alpha: 1)
    var deselected_Color = UIColor.black
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSegmentLayout(nIndex: nSegIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Buttons' Event
    @IBAction func click_btn_Back(_ sender: AnyObject) {
    }
    
    @IBAction func click_btn_Search(_ sender: AnyObject) {
    }

    @IBAction func click_btn_Segment01(_ sender: AnyObject) {
        nSegIndex = 0
        setSegmentLayout(nIndex: nSegIndex)
        tbl_List.reloadData()
    }
    
    @IBAction func click_btn_Segment02(_ sender: AnyObject) {
        nSegIndex = 1
        setSegmentLayout(nIndex: nSegIndex)
        tbl_List.reloadData()
    }
    
    @IBAction func click_btn_Segment03(_ sender: AnyObject) {
        nSegIndex = 2
        setSegmentLayout(nIndex: nSegIndex)
        tbl_List.reloadData()
    }
    
    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (nSegIndex == 0 || nSegIndex == 1){
            return 60
        }else{
            if (indexPath.row == 0 || indexPath.row == 1){
                return 60
            }else if (indexPath.row == 2){
                return 180
            }else{
                return 180
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (nSegIndex == 0){
            return 20
        }else if (nSegIndex == 1){
            return 6
        }else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell01")! as UITableViewCell
        
        if (nSegIndex == 0 || nSegIndex == 1){
            cell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell01")! as UITableViewCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let img_Avatar = cell.viewWithTag(100) as? UIImageView
            img_Avatar?.image = UIImage.init(named: "Home_img_Sample.png")
            img_Avatar?.layer.cornerRadius = (img_Avatar?.frame.size.height)! / 2
            img_Avatar?.layer.masksToBounds = true
            img_Avatar?.layer.borderWidth = 0
            img_Avatar?.layer.borderColor = UIColor.gray.cgColor
        }else{
            if (indexPath.row == 0){
                cell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell02")! as UITableViewCell
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            }else if (indexPath.row == 1){
                cell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell03")! as UITableViewCell
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            }else{
                cell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell04")! as UITableViewCell
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                let lbl_User = cell.viewWithTag(100) as? UILabel
                let lbl_Description = cell.viewWithTag(200) as? UILabel
                
                if (indexPath.row == 2){
                    lbl_User?.text = "Dug2Guns"
                    lbl_Description?.text = "Linked you to a motiff at 12:30"
                }else if (indexPath.row == 3){
                    lbl_User?.text = "Gavyin1Up"
                    lbl_Description?.text = "Shared you post in Twitter at 13:00"
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - setSegmentLayout
    func setSegmentLayout(nIndex: Int){
        if (nIndex == 0){
            lbl_SegTitle01.textColor = selected_Color
            lbl_SegNumber01.textColor = selected_Color
            lbl_SegUnderLine01.backgroundColor = selected_Color
        }else{
            lbl_SegTitle01.textColor = deselected_Color
            lbl_SegNumber01.textColor = deselected_Color
            lbl_SegUnderLine01.backgroundColor = UIColor.clear
        }
        
        if (nIndex == 1){
            lbl_SegTitle02.textColor = selected_Color
            lbl_SegNumber02.textColor = selected_Color
            lbl_SegUnderLine02.backgroundColor = selected_Color
        }else{
            lbl_SegTitle02.textColor = deselected_Color
            lbl_SegNumber02.textColor = deselected_Color
            lbl_SegUnderLine02.backgroundColor = UIColor.clear
        }
        
        if (nIndex == 2){
            lbl_SegTitle03.textColor = selected_Color
            lbl_SegNumber03.textColor = selected_Color
            lbl_SegUnderLine03.backgroundColor = selected_Color
        }else{
            lbl_SegTitle03.textColor = deselected_Color
            lbl_SegNumber03.textColor = deselected_Color
            lbl_SegUnderLine03.backgroundColor = UIColor.clear
        }
    }
    

}

//
//  SettingTBCell01.swift
//  My-Mo
//
//  Created by iDeveloper on 12/1/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

protocol SettingTBCell01Delegate {
    func edit_Caption(cell: SettingTBCell01)
    func ended_Editing_Caption(cell: SettingTBCell01)
}

class SettingTBCell01: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var view_Board: UIView!
    @IBOutlet weak var txt_Caption: UITextField!
    @IBOutlet weak var btn_Edit: UIButton!
    
    var cellDelegate: SettingTBCell01Delegate?
    var nType: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - Buttons' Events
    @IBAction func click_btn_Edit(_ sender: AnyObject) {
        if (txt_Caption.isEnabled == false){
            txt_Caption.isEnabled = true
            txt_Caption.becomeFirstResponder()

        }else{
            txt_Caption.resignFirstResponder()
            txt_Caption.isEnabled = false
        }
        
        cellDelegate?.edit_Caption(cell: self)
    }
    
    //MARK: - Move UIView When Keyboard appear
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //        animateViewMoving(true, moveValue: 167)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        cellDelegate?.ended_Editing_Caption(cell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        txt_Caption.isEnabled = false
        return true
    }
}

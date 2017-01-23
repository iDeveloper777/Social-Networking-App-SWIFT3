//
//  SettingTBCell02.swift
//  My-Mo
//
//  Created by iDeveloper on 12/1/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

protocol SettingTBCell02Delegate {
    func select_Caption(cell: SettingTBCell02)
}

class SettingTBCell02: UITableViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var view_Board: UIView!
    @IBOutlet weak var lbl_Caption: UILabel!
    @IBOutlet weak var btn_Select: UIButton!
    
    
    var cellDelegate: SettingTBCell02Delegate?

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
    @IBAction func click_btn_Select(_ sender: AnyObject) {
        cellDelegate?.select_Caption(cell: self)
    }
    
}

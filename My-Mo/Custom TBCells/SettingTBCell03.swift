//
//  SettingTBCell03.swift
//  My-Mo
//
//  Created by iDeveloper on 12/30/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

protocol SettingTBCell03Delegate {
    func change_Selector(cell: SettingTBCell03)
}

class SettingTBCell03: UITableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Caption: UILabel!
    @IBOutlet weak var sw_Selector: UISwitch!
    
    var cellDelegate: SettingTBCell03Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        sw_Selector?.layer.borderWidth = 1
        sw_Selector?.layer.borderColor = UIColor.lightGray.cgColor
        sw_Selector?.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sw_changed_Selector(_ sender: Any) {
        cellDelegate?.change_Selector(cell: self)
    }
}

//
//  PhoneBookTBCell02.swift
//  My-Mo
//
//  Created by iDeveloper on 1/26/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import UIKit

protocol PhoneBookTBCell02Delegate {
    func select_btn_SMS(cell: PhoneBookTBCell02)
}

class PhoneBookTBCell02: UITableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_SMS: UIButton!
    
    var cellDelegate: PhoneBookTBCell02Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func click_btn_SMS(_ sender: Any) {
        cellDelegate?.select_btn_SMS(cell: self)
    }
}

//
//  PhoneBookTBCell01.swift
//  My-Mo
//
//  Created by iDeveloper on 1/26/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import UIKit

protocol PhoneBookTBCell01Delegate {
    func select_btn_Follow(cell: PhoneBookTBCell01)
}

class PhoneBookTBCell01: UITableViewCell {

    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Character: UILabel!
    @IBOutlet weak var btn_Follow: UIButton!
    
    var cellDelegate: PhoneBookTBCell01Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        img_Avatar?.layer.cornerRadius = (img_Avatar?.frame.size.height)! / 2
        img_Avatar?.layer.masksToBounds = true
        img_Avatar?.layer.borderWidth = 0
        img_Avatar?.layer.borderColor = UIColor(red: 238/255, green: 125/255, blue: 49/255, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func click_btn_Follow(_ sender: Any) {
        cellDelegate?.select_btn_Follow(cell: self)
    }
}

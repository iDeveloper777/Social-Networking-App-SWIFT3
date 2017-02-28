//
//  LikeUserTBCell.swift
//  My-Mo
//
//  Created by iDeveloper on 2/15/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import UIKit

protocol LikeUserTBCellDelegate {
    func select_btn_Follow(cell: LikeUserTBCell)
}

class LikeUserTBCell: UITableViewCell {

    @IBOutlet weak var btn_Follow: UIButton!
    @IBOutlet weak var view_Swipe: UIView!
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    
    var cellDelegate: LikeUserTBCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        img_Avatar?.layer.cornerRadius = (img_Avatar?.frame.size.height)! / 2
        img_Avatar?.layer.masksToBounds = true
        img_Avatar?.layer.borderWidth = 0
        img_Avatar?.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func click_btn_Follow(_ sender: Any) {
        cellDelegate?.select_btn_Follow(cell: self)
    }
}

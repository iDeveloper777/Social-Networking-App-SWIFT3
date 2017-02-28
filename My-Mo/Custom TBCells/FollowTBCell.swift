//
//  FollowTBCell.swift
//  My-Mo
//
//  Created by iDeveloper on 2/14/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import UIKit

protocol FollowTBCellDelegate {
    func select_btn_UnFollow(cell: FollowTBCell)
}

class FollowTBCell: UITableViewCell {

    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Followers: UILabel!
    @IBOutlet weak var btn_UnFollow: UIButton!
    
    var cellDelegate: FollowTBCellDelegate?
    
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

    @IBAction func click_btn_UnFollow(_ sender: Any) {
        cellDelegate?.select_btn_UnFollow(cell: self)
    }
}

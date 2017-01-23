//
//  HomeTBCell.swift
//  My-Mo
//
//  Created by iDeveloper on 12/23/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

protocol HomeTBCellDelegate {
    func select_ProfileImage(cell: HomeTBCell)
}

class HomeTBCell: UITableViewCell {
    
    @IBOutlet weak var img_Left_Arrow: UIImageView!
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_BadgeNumber: UILabel!
    
    var nBadgeNumber: Int = 0
    var cellDelegate: HomeTBCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    
        setLayout()
    }

    func setLayout(){
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        self.img_Left_Arrow.image = UIImage.init(named: "Home_img_Left.png")
        
        self.img_Avatar.layer.cornerRadius = (self.img_Avatar.frame.size.height) / 2
        self.img_Avatar.layer.masksToBounds = true
        self.img_Avatar?.layer.borderWidth = 1
        self.img_Avatar?.layer.borderColor = UIColor.orange.cgColor
        
        //TapGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapGesture))
        img_Avatar?.addGestureRecognizer(tapGesture)
        img_Avatar?.isUserInteractionEnabled = true
        
        //Badge Number
        lbl_BadgeNumber.layer.cornerRadius = (lbl_BadgeNumber.frame.size.height) / 2
        lbl_BadgeNumber.layer.masksToBounds = true
        lbl_BadgeNumber.layer.borderWidth = 1
        lbl_BadgeNumber.layer.borderColor = UIColor(red: 0/255, green: 150/255, blue: 0/255, alpha: 0.9).cgColor
    }
    
    func setBadgeNumber(badgeNumber: Int){
        nBadgeNumber = badgeNumber
        if nBadgeNumber != 0 {
//            lbl_BadgeNumber.text = String(nBadgeNumber)
            lbl_BadgeNumber.text = ""
//            lbl_BadgeNumber.sizeToFit()
        }else{
            lbl_BadgeNumber.isHidden = true
        }
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func profileTapGesture(sender: UITapGestureRecognizer){
        cellDelegate?.select_ProfileImage(cell: self)
    }
}

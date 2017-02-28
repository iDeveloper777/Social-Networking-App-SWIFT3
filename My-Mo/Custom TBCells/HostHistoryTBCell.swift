//
//  HostHistoryTBCell.swift
//  My-Mo
//
//  Created by iDeveloper on 1/5/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import UIKit

protocol HostHistoryTBCellDelegate {
    func click_ViewMoreComments_Button(cell: HostHistoryTBCell)
    func click_Likes_Button(cell: HostHistoryTBCell)
    func click_Play_Video(cell: HostHistoryTBCell)
    func click_More_Button(cell: HostHistoryTBCell)
}

class HostHistoryTBCell: UITableViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var btn_More: UIButton!
    @IBOutlet weak var img_Motiff: UIImageView!
    @IBOutlet weak var btn_PlayVideo: UIButton!
    
    @IBOutlet weak var lbl_ViewLikes: UILabel!
    @IBOutlet weak var btn_Like: UIButton!
    @IBOutlet weak var lbl_Like_Numbers: UILabel!
    @IBOutlet weak var btn_ViewMoreComments: UIButton!
    @IBOutlet weak var lbl_Description: UILabel!
    
    @IBOutlet weak var img_Comment_Avatar01: UIImageView!
    @IBOutlet weak var lbl_Comment_Name01: UILabel!
    @IBOutlet weak var lbl_Comment_Text01: UILabel!
    @IBOutlet weak var lbl_Comment_Date01: UILabel!
    @IBOutlet weak var img_Comment_Right01: UIImageView!
    @IBOutlet weak var lbl_Comment_Line01: UILabel!
    
    @IBOutlet weak var img_Comment_Avatar02: UIImageView!
    @IBOutlet weak var lbl_Comment_Name02: UILabel!
    @IBOutlet weak var lbl_Comment_Text02: UILabel!
    @IBOutlet weak var lbl_Comment_Date02: UILabel!
    @IBOutlet weak var img_Comment_Right02: UIImageView!
    @IBOutlet weak var lbl_Comment_Line02: UILabel!
    
    var cellDelegate: HostHistoryTBCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        img_Motiff?.layer.cornerRadius = 8
        img_Motiff?.layer.masksToBounds = true
        img_Motiff?.layer.borderWidth = 0
        img_Motiff?.layer.borderColor = UIColor.gray.cgColor

        /*
        img_Comment_Avatar01?.layer.cornerRadius = (img_Comment_Avatar01?.frame.size.height)! / 2
        img_Comment_Avatar01?.layer.masksToBounds = true
        img_Comment_Avatar01?.layer.borderWidth = 0
        img_Comment_Avatar01?.layer.borderColor = UIColor.gray.cgColor
        
        img_Comment_Avatar02?.layer.cornerRadius = (img_Comment_Avatar02?.frame.size.height)! / 2
        img_Comment_Avatar02?.layer.masksToBounds = true
        img_Comment_Avatar02?.layer.borderWidth = 0
        img_Comment_Avatar02?.layer.borderColor = UIColor.gray.cgColor
        
        
        lbl_Comment_Date01.isHidden = true
        lbl_Comment_Date02.isHidden = true
        */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func click_btn_ViewMoreComments(_ sender: Any) {
        cellDelegate?.click_ViewMoreComments_Button(cell: self)
        
    }
    
    @IBAction func click_btn_LIkes(_ sender: Any) {
        cellDelegate?.click_Likes_Button(cell: self)
    }

    @IBAction func click_btn_PlayVideo(_ sender: Any) {
        cellDelegate?.click_Play_Video(cell: self)
    }
    
    @IBAction func click_btn_More(_ sender: Any) {
        cellDelegate?.click_More_Button(cell: self)
    }
    
}

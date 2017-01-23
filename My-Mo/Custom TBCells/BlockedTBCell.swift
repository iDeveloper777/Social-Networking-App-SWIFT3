//
//  BlockedTBCell.swift
//  My-Mo
//
//  Created by iDeveloper on 1/3/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import UIKit

protocol BlockedTBCellDelegate {
    func change_Block_Button(cell: BlockedTBCell)
}

class BlockedTBCell: UITableViewCell {

    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var btn_Block: UIButton!
    
    var is_Blocked: Int = 0
    
    var cellDelegate: BlockedTBCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        img_Avatar?.layer.cornerRadius = (img_Avatar?.frame.size.height)! / 2
        img_Avatar?.layer.masksToBounds = true
        img_Avatar?.layer.borderWidth = 1
        self.img_Avatar?.layer.borderColor = UIColor.orange.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func change_Btn_Option(option: Int){
        if (option == 1){
//            is_Blocked = 0
            btn_Block?.setTitle("UnBlock", for: .normal)
            btn_Block?.setTitleColor(UIColor.lightGray, for: .normal)
        }else{
//            is_Blocked = 1
            btn_Block?.setTitle("Block", for: .normal)
            btn_Block?.setTitleColor(UIColor.darkGray, for: .normal)
        }
    }
    
    @IBAction func click_btn_Block(_ sender: Any) {
        cellDelegate?.change_Block_Button(cell: self)
    }
}

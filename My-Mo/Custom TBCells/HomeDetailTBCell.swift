//
//  HomeDetailTBCell.swift
//  My-Mo
//
//  Created by iDeveloper on 12/29/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

protocol HomeDetailTBCellDelegate {
    func select_btn_Delete(cell: HomeDetailTBCell)
}

class HomeDetailTBCell: UITableViewCell {

    @IBOutlet weak var view_Swipe: UIView!
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Comment: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var btn_Delete: UIButton!
    
    var cellDelegate: HomeDetailTBCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLayout()
    }

    func setLayout(){
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        self.img_Avatar.layer.cornerRadius = (self.img_Avatar.frame.size.height) / 2
        self.img_Avatar.layer.masksToBounds = true
        self.img_Avatar?.layer.borderWidth = 1
        self.img_Avatar?.layer.borderColor = UIColor.orange.cgColor
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func click_btn_Delete(_ sender: Any) {
        cellDelegate?.select_btn_Delete(cell: self)
    }
    
    
}

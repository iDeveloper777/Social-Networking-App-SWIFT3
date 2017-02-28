//
//  MessageViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/9/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Users: UIView!
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
    @IBOutlet weak var scr_Users: UIScrollView!
    @IBOutlet weak var img_User01: UIImageView!
    @IBOutlet weak var img_User02: UIImageView!
    @IBOutlet weak var img_User03: UIImageView!
    @IBOutlet weak var img_User04: UIImageView!
    @IBOutlet weak var img_User05: UIImageView!
    @IBOutlet weak var img_User06: UIImageView!
    @IBOutlet weak var img_User07: UIImageView!
    @IBOutlet weak var img_User08: UIImageView!

    var x_Button = 0
    var indexTitles:[String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUserImagesLayout()
        setButtonsLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUserImagesLayout(){
        scr_Users.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: COMMON.HEIGHT(view: scr_Users))
        scr_Users.contentSize = CGSize(width: 545, height: COMMON.HEIGHT(view: scr_Users))
        
        img_User01?.layer.cornerRadius = (img_User01?.frame.size.height)! / 2
        img_User01?.layer.masksToBounds = true
        img_User02?.layer.cornerRadius = (img_User02?.frame.size.height)! / 2
        img_User02?.layer.masksToBounds = true
        img_User03?.layer.cornerRadius = (img_User03?.frame.size.height)! / 2
        img_User03?.layer.masksToBounds = true
        img_User04?.layer.cornerRadius = (img_User01?.frame.size.height)! / 2
        img_User04?.layer.masksToBounds = true
        img_User05?.layer.cornerRadius = (img_User05?.frame.size.height)! / 2
        img_User05?.layer.masksToBounds = true
        img_User06?.layer.cornerRadius = (img_User06?.frame.size.height)! / 2
        img_User06?.layer.masksToBounds = true
        img_User07?.layer.cornerRadius = (img_User07?.frame.size.height)! / 2
        img_User07?.layer.masksToBounds = true
        img_User08?.layer.cornerRadius = (img_User08?.frame.size.height)! / 2
        img_User08?.layer.masksToBounds = true
    }
    
    func setButtonsLayout(){
        var temp_distance = 0
        var tagValue = 1000
        x_Button = Int(Main_Screen_Width) / (indexTitles.count + 2)
        temp_distance = x_Button
        
        x_Button = (Int(Main_Screen_Width) - (temp_distance * (indexTitles.count + 0)))/2
        
        let letter_Y = (COMMON.HEIGHT(view: view_Users) - COMMON.HEIGHT(view: scr_Users) - 15) / 2 + COMMON.HEIGHT(view: scr_Users) - 2
        
        //adding A to Z index
        for k in (0..<indexTitles.count) {
            
            let index = UIButton(frame: CGRect(x: CGFloat(x_Button), y: letter_Y, width: CGFloat(temp_distance), height: 15))
            index.setTitle(indexTitles[k], for: .normal)
            index.titleLabel!.font = UIFont.systemFont(ofSize: 12.0)
            index.tag = tagValue
            index.setTitleColor(UIColor.gray, for: .normal)
            index.titleLabel!.textAlignment = .center
            index.titleLabel!.adjustsFontSizeToFitWidth = true
            index.addTarget(self, action: #selector(reloading(sender:)), for: .touchUpInside)
            view_Users.addSubview(index)
            tagValue += 1
            x_Button = x_Button + temp_distance
        }
    }
    
    func reloading(sender: UIButton) {
        
    }
    // MARK: - Buttons' Event

    @IBAction func click_btn_Back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tbl_List.dequeueReusableCell(withIdentifier: "DirectMessageCell")! as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let img_Avatar = cell.viewWithTag(100) as? UIImageView
        img_Avatar?.image = UIImage.init(named: "Home_img_Sample.png")
        img_Avatar?.layer.cornerRadius = (img_Avatar?.frame.size.height)! / 2
        img_Avatar?.layer.masksToBounds = true
        img_Avatar?.layer.borderWidth = 0
        img_Avatar?.layer.borderColor = UIColor.gray.cgColor
        
        if (indexPath.row < 3){
            let btn_Right = cell.viewWithTag(300) as? UIButton
            btn_Right?.isHidden = true
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MessageBoardView") as! MessageBoardViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)

    }
}

//
//  LikesViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/14/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
    var strTileArray:[String] = []
    var strImageArray:[String] = []
    var swipeArray:[Int] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableTitle()
        initDatas()
    }

    func initTableTitle(){
        strTileArray = ["JenJen", "Chhavi", "Dug"]
        strImageArray = ["Home_img_Sample01.png", "Home_img_Sample.png", "Home_img_Sample03.png"]
        
    }
    
    func initDatas(){
        for _ in (0..<3) {
            swipeArray.append(0)
        }
    }
    
    // MARK: - Buttons' Events    
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
        return strImageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tbl_List.dequeueReusableCell(withIdentifier: "LikesCell")! as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let img_Avatar = cell.viewWithTag(100) as? UIImageView
        img_Avatar?.image = UIImage.init(named: strImageArray[indexPath.row])
        img_Avatar?.layer.cornerRadius = (img_Avatar?.frame.size.height)! / 2
        img_Avatar?.layer.masksToBounds = true
        img_Avatar?.layer.borderWidth = 0
        img_Avatar?.layer.borderColor = UIColor.gray.cgColor
        
        let lbl_Title = cell.viewWithTag(200) as? UILabel
        lbl_Title?.text = strTileArray[indexPath.row]
        
        //SwipeGesture
        cell.tag = indexPath.row
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftCell))
        swipeLeftGesture.direction = .left
        cell.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightCell))
        swipeRightGesture.direction = .right
        cell.addGestureRecognizer(swipeRightGesture)
        
        var lbl_Date: UILabel! = nil
        var btn_Likes: UIButton! = nil
        for subview in cell.contentView.subviews {
            if subview is UIButton {
                btn_Likes = subview as! UIButton
                
                btn_Likes?.addTarget(self, action: #selector(pressedLikesButton), for: .touchUpInside)
                btn_Likes?.tag = 10000 + indexPath.row
                btn_Likes.frame = CGRect(x: COMMON.X(view: btn_Likes),
                                         y: COMMON.Y(view: btn_Likes),
                                         width: COMMON.HEIGHT(view: btn_Likes),
                                         height: COMMON.HEIGHT(view: btn_Likes))
                
                
            }
            
            if subview is UILabel {
                lbl_Date = subview as! UILabel
                
                if (lbl_Date.backgroundColor == UIColor.white){
                    lbl_Date?.tag = 300000 + indexPath.row
                    
                    if (swipeArray[indexPath.row] == 0){
                        let rect:CGRect = CGRect(x: COMMON.WIDTH(view: cell.contentView) - COMMON.WIDTH(view: lbl_Date), y: COMMON.Y(view: lbl_Date), width: COMMON.WIDTH(view: lbl_Date), height: COMMON.HEIGHT(view: lbl_Date))
                        
                        lbl_Date.frame = rect
                    }else{
                        let rect:CGRect = CGRect(x: COMMON.WIDTH(view: cell.contentView) - COMMON.WIDTH(view: lbl_Date) - 50, y: COMMON.Y(view: lbl_Date), width: COMMON.WIDTH(view: lbl_Date), height: COMMON.HEIGHT(view: lbl_Date))
                        
                        lbl_Date.frame = rect
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func pressedLikesButton(sender: UIButton){
        print(sender.tag)
    }

    //MARK: - Swipe Getures
    func swipeLeftCell(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! UITableViewCell
        let lbl_Date = cell.viewWithTag(300000 + cell.tag)! as! UILabel
        
        swipeArray[cell.tag] = 1
        
        if (swipeArray[cell.tag] == 1){
            UIView.animate(withDuration: 0.5, animations: {
                lbl_Date.frame = CGRect(x: COMMON.WIDTH(view: cell.contentView) - COMMON.WIDTH(view: lbl_Date) - 50, y: COMMON.Y(view: lbl_Date), width: COMMON.WIDTH(view: lbl_Date), height: COMMON.HEIGHT(view: lbl_Date))
            })
            
        }
    }
    
    
    func swipeRightCell(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! UITableViewCell
        let lbl_Date = cell.viewWithTag(300000 + cell.tag)! as! UILabel
        
        swipeArray[cell.tag] = 0
        
        if (swipeArray[cell.tag] == 0){
            UIView.animate(withDuration: 0.5, animations: {
                lbl_Date.frame = CGRect(x: COMMON.WIDTH(view: cell.contentView) - COMMON.WIDTH(view: lbl_Date), y: COMMON.Y(view: lbl_Date), width: COMMON.WIDTH(view: lbl_Date), height: COMMON.HEIGHT(view: lbl_Date))
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

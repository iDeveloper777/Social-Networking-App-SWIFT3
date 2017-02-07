//
//  TabBarViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 10/13/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 0){ //Hide Badge Number
            NotificationCenter.default.post(name: Notification.Name(kNoti_Hide_Home_BadgeNumber), object: nil)
        }else{
            NotificationCenter.default.post(name: Notification.Name(kNoti_Show_Home_BadgeNumber), object: nil)
        }
    }
}

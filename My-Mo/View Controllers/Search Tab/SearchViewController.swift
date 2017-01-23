//
//  SearchViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/5/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Buttons' Events
    @IBAction func click_btn_Back(_ sender: AnyObject) {
    }
    
    @IBAction func click_btn_Username(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchUsernameView") as! SearchUsernameViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func click_btn_Phonebook(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchPhonebookView") as! SearchPhonebookViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func click_btn_World(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchWorldView") as! SearchWorldViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func click_btn_Map(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchMapView") as! SearchMapViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

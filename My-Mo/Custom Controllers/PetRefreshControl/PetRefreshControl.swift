//
//  PetRefreshControl.swift
//  My-Mo
//
//  Created by iDeveloper on 3/15/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import UIKit

@IBDesignable

class PetRefreshControl: UIRefreshControl {

//    var loadingImageView: FLAnimatedImageView!
    
    override init(){
        super.init()
//        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        let view0: UIView? = self.subviews[0].subviews[0]
        if view0 != nil {
            view0?.isHidden = true
        }
        
        let view: UIView? = self.subviews[0]
        if  view != nil {
            if (view?.subviews[(view?.subviews.count)!-1] as? FLAnimatedImageView) != nil {
//                image.removeFromSuperview()
            }else{
                let screenSize = UIScreen.main.bounds
                
                let loadingImageView: FLAnimatedImageView = FLAnimatedImageView(frame: CGRect(x: (screenSize.width/2) - 30, y: 0, width: 60, height: 60))
                
                
                if let path =  Bundle.main.path(forResource: "loading", ofType: "gif") {
                    if let data = NSData(contentsOfFile: path) {
                        let gif = FLAnimatedImage(animatedGIFData: data as Data!)
                        loadingImageView.animatedImage = gif
                    }
                }
                
                view?.addSubview(loadingImageView)

            }
            
        }

    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        setup()
    }
    
    override func endRefreshing() {
        super.endRefreshing()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

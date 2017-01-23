//
//  ImageCropViewController.h
//  MyGooi
//
//  Created by BLT0003-MACBK on 23/06/14.
//  Copyright (c) 2014 Vijayakumar. All rights reserved.
//

#import <UIKit/UIKit.h>
//Custom delegate
@protocol CropImageDelegate <NSObject>

-(void)imageCropFinished:(UIImage *)image;

@end

@interface ImageCropViewController : UIViewController
// set delegate in viewcontroller
@property id <CropImageDelegate> delegate;
//crop image
@property (retain,nonatomic) UIImage *image;

@property(nonatomic,assign) CGFloat ratioOfWidthAndHeight; //

-(void)presentViewControllerAnimated:(BOOL)animation;


@end

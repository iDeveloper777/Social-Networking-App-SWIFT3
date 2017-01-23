//
//  ImageCropViewController.m
//  MyGooi
//
//  Created by BLT0003-MACBK on 23/06/14.
//  Copyright (c) 2014 Vijayakumar. All rights reserved.
//

#import "ImageCropViewController.h"

//User Define Class
#define kDefualRatioOfWidthAndHeight 1.0f

@interface UIImage (ImageCropAddition)

- (UIImage*)imageCropRect:(CGRect)targetRect;
- (UIImage *)imageCropSetOrientation;

@end

@implementation UIImage (ImageCropAddition)


/***
 Method Name : imageCropSetOrientation
 Input Parameter : nil
 Return Type : UIImage
 Method Description : set image orientation preparing to crop
 ***/
- (UIImage *)imageCropSetOrientation {
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIImageOrientation io = self.imageOrientation;
    if (io == UIImageOrientationDown || io == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
    }else if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
    }else if (io == UIImageOrientationRight || io == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, 0, self.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        
    }
    
    if (io == UIImageOrientationUpMirrored || io == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }else if (io == UIImageOrientationLeftMirrored || io == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored || io == UIImageOrientationRight || io == UIImageOrientationRightMirrored) {
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
    }else{
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
/***
 Method Name : imageCropRect
 Input Parameter : CGRect
 Return Type : UIImage
 Method Description : to crop image to give orgin and size
 ***/
- (UIImage*)imageCropRect:(CGRect)targetRect
{
    targetRect.origin.x*=self.scale;
    targetRect.origin.y*=self.scale;
    targetRect.size.width*=self.scale;
    targetRect.size.height*=self.scale;
    
    if (targetRect.origin.x<0) {
        targetRect.origin.x = 0;
    }
    if (targetRect.origin.y<0) {
        targetRect.origin.y = 0;
    }
    
     CGFloat cgWidth = CGImageGetWidth(self.CGImage);
    CGFloat cgHeight = CGImageGetHeight(self.CGImage);
    if (CGRectGetMaxX(targetRect)>cgWidth) {
        targetRect.size.width = cgWidth-targetRect.origin.x;
    }
    if (CGRectGetMaxY(targetRect)>cgHeight) {
        targetRect.size.height = cgHeight-targetRect.origin.y;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, targetRect);
    UIImage *resultImage=[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
     resultImage = [UIImage imageWithCGImage:resultImage.CGImage scale:self.scale orientation:self.imageOrientation];
    
    return resultImage;
}

@end

@interface ImageCropViewController ()<UIScrollViewDelegate>

    @property(nonatomic,retain) UIScrollView *scrollView;
    @property(nonatomic,retain) UIView *overlayView;

    @property(nonatomic,retain) UIImageView *imageView;
    
    @property(nonatomic,retain) UIWindow *actionWindow;
    
    @property(nonatomic,retain) UIView *topBlackView;
    @property(nonatomic,retain) UIView *bottomBlackView;
    @property(nonatomic,retain) UIView *buttonBackgroundView;
    @property(nonatomic,retain) UIButton *cancelButton;
    @property(nonatomic,retain) UIButton *confirmButton;
@property(nonatomic,retain)UIActivityIndicatorView *activityIndicator;

    @property (assign, nonatomic) int imageWidth;
    @property (assign, nonatomic) int imageHeight;
@end

@implementation ImageCropViewController
@synthesize imageHeight, imageWidth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ratioOfWidthAndHeight = kDefualRatioOfWidthAndHeight;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    imageWidth = appDelegate.imageWidth;
//    imageHeight = appDelegate.imageHeight;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.activityIndicator stopAnimating];
    
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator setHidesWhenStopped:YES];

    self.scrollView.frame = self.view.bounds;
    self.overlayView.layer.borderColor = [UIColor colorWithWhite:0.966 alpha:1.000].CGColor;
    
     [self.view addSubview:self.topBlackView = [self acquireBlackTransparentOverlayView]];
    [self.view addSubview:self.bottomBlackView = [self acquireBlackTransparentOverlayView]];
    
     UIView *buttonBackgroundView = [[UIView alloc]init];
    buttonBackgroundView.userInteractionEnabled = NO;
//    UIColor *backColor = [UIColor greenColor];
    
    UIColor *backColor = [UIColor colorWithRed:245/255.f green:116/255.f blue:44/255.f alpha:1];
    buttonBackgroundView.backgroundColor = backColor;
    buttonBackgroundView.layer.opacity = 0.8f;
    [self.view addSubview:self.buttonBackgroundView = buttonBackgroundView];
    
     [self.view addSubview:self.cancelButton = [self acquireCustomButtonWithTitle:@"Cancel" andAction:@selector(onCancel:)]];
    [self.view addSubview:self.confirmButton = [self acquireCustomButtonWithTitle:@"Crop" andAction:@selector(onConfirm:)]];
    
    
     UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark create view helper
/***
 Method Name : acquireBlackTransparentOverlayView
 Input Parameter : nill
 Return Type : UIView
 Method Description :to create view in transparent
 ***/
- (UIView*)acquireBlackTransparentOverlayView
{
    UIView *view = [[UIView alloc]init];
    view.userInteractionEnabled = NO;
    view.backgroundColor = [UIColor blackColor];
    view.layer.opacity = 0.25f;
    return view;
}
/***
 Method Name : acquireCustomButtonWithTitle:title:andAction
 Input Parameter : NSString , SEL (selector)
 Return Type : UIView
 Method Description :reuse button create and set action
 ***/
- (UIButton *)acquireCustomButtonWithTitle:(NSString*)title andAction:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    return button;
}

#pragma mark - PresentViewController
/***
 Method Name : presentViewControllerAnimated
 Input Parameter : BOOL
 Return Type : nil
 Method Description :presentViewController in crop image if aniamttion used to present or not
 ***/
-(void)presentViewControllerAnimated:(BOOL)animation;
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.opaque = YES;
    window.windowLevel = UIWindowLevelStatusBar+1.0f;
    window.rootViewController = self;
    [window makeKeyAndVisible];
    self.actionWindow = window;
    
    if (animation) {
        self.actionWindow.layer.opacity = .01f;
        [UIView animateWithDuration:0.35f animations:^{
            self.actionWindow.layer.opacity = 1.0f;
        }];
    }
}

#pragma mark - DismissView Controller
/***
 Method Name : disappear
 Input Parameter : BOOL
 Return Type : nil
 Method Description :Dismiss in crop
 ***/
- (void)disappear
{
     [UIView animateWithDuration:0.5f animations:^{
        self.actionWindow.layer.opacity = 0.01f;
    } completion:^(BOOL finished) {
        [self.actionWindow removeFromSuperview];
        [self.actionWindow resignKeyWindow];
        self.actionWindow = nil;
    }];
}
/***
 Method Name : onCancel
 Input Parameter : any object (UIButton)
 Return Type : nil
 Method Description :user click cancel crop the image
 ***/
- (void)onCancel:(id)sender
{
    [self disappear];
}
/***
 Method Name : onConfirm
 Input Parameter : any object (UIButton)
 Return Type : nil
 Method Description :user click Crop button crop the image dismis view called delegate in present viewcontroller
 ***/
- (void)onConfirm:(id)sender
{
    [self.activityIndicator setHidden:NO];
 
    [self performSelector:@selector(conformationSucess) withObject:nil];
}
-(void)conformationSucess
{
    if (!self.imageView.image) {
        return;
    }
    if (self.scrollView.tracking||self.scrollView.dragging||self.scrollView.decelerating||self.scrollView.zoomBouncing||self.scrollView.zooming){
        return;
    }
    CGPoint startPoint = [self.overlayView convertPoint:CGPointZero toView:self.imageView];
    CGPoint endPoint = [self.overlayView convertPoint:CGPointMake(CGRectGetMaxX(self.overlayView.bounds), CGRectGetMaxY(self.overlayView.bounds)) toView:self.imageView];
    CGFloat wRatio = self.imageView.image.size.width/(self.imageView.frame.size.width/self.scrollView.zoomScale);
    CGFloat hRatio = self.imageView.image.size.height/(self.imageView.frame.size.height/self.scrollView.zoomScale);
    CGRect cropRect = CGRectMake(startPoint.x*wRatio, startPoint.y*hRatio, (endPoint.x-startPoint.x)*wRatio, (endPoint.y-startPoint.y)*hRatio);
    
    [self disappear];
    
    UIImage *cropImage = [self.imageView.image imageCropRect:cropRect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropFinished:)]){
        [self.delegate imageCropFinished:cropImage];
    }
}
#pragma mark - Double tap to Zoom
/***
 Method Name : handleDoubleTap
 Input Parameter : UITapGestureRecognizer
 Return Type : nil
 Method Description :user click double tap image automaticall zoom
 ***/
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self.scrollView];
	if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	} else {
		[self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
	}
}

#pragma mark - getter or setter
/***
 Method Name : setImage
 Input Parameter : UIImage
 Return Type : nil
 Method Description : set crop original image
 ***/
- (void)setImage:(UIImage *)image
{
    if ([image isEqual:_image]) {
        return;
    }
    _image = image;
    
     self.imageView.image = [image imageCropSetOrientation];
    if (self.isViewLoaded) {
        [self.view setNeedsLayout];
    }
}

/***
 Method Name : setRatioOfWidthAndHeight
 Input Parameter : CGFloat
 Return Type : nil
 Method Description : set  image ratio Of Width And Height in to crop image
 ***/

- (void)setRatioOfWidthAndHeight:(CGFloat)ratioOfWidthAndHeight
{
//    _ratioOfWidthAndHeight = 640.f/480.f;
    

    imageWidth = 640.f;
    imageHeight = 640.f;
    
    _ratioOfWidthAndHeight = (float)imageWidth/(float)imageHeight;
    
    return;
//    if (ratioOfWidthAndHeight<=0) {
//        ratioOfWidthAndHeight = kDefualRatioOfWidthAndHeight;
//    }
//    if (ratioOfWidthAndHeight==_ratioOfWidthAndHeight) {
//        return;
//    }
//    _ratioOfWidthAndHeight = ratioOfWidthAndHeight;
//
//    if (self.isViewLoaded) {
//        [self.view setNeedsLayout];
//    }
}
/***
 Method Name : overlayView
 Input Parameter : CGFloat
 Return Type : UIView
 Method Description : create Overlay View in crop boarder
 ***/
- (UIView*)overlayView
{
    if (!_overlayView) {
        _overlayView = [[UIView alloc]init];
        
        _overlayView.layer.borderColor = [UIColor whiteColor].CGColor;
        _overlayView.layer.borderWidth = 1.0f;
        _overlayView.userInteractionEnabled = NO;
        [self.view addSubview:_overlayView];
    }
    return _overlayView;
}
/***
 Method Name : scrollView
 Input Parameter : UIScrollView
 Return Type : UIScrollView
 Method Description : create scrollView using zoom and scroll the imageView
 ***/
- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.exclusiveTouch = YES;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
/***
 Method Name : imageView
 Input Parameter : nil
 Return Type : UIImageView
 Method Description : create UIImageView using set image
 ***/
- (UIImageView*)imageView
{
    if (!_imageView) {
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
        //                _imageView.backgroundColor = [UIColor yellowColor];
		[self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - other
/***
 Method Name : isBaseOnWidthOfOverlayView
 Input Parameter : nil
 Return Type : BOOL
 Method Description : check base view width in overlay view
 ***/
 - (BOOL)isBaseOnWidthOfOverlayView
{
     if (self.overlayView.frame.size.width < self.view.bounds.size.width) {
        return NO;
    }
    return YES;
}

#pragma mark - layout
/***
 Method Name : viewDidLayoutSubviews
 Input Parameter : nil
 Return Type : nil
 Method Description : to set layout from button and scrollview ,overlayview, bottomblackview
 ***/
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.view sendSubviewToBack:self.scrollView];
    
#define kButtonViewHeight 50
    self.buttonBackgroundView.frame = CGRectMake(0,0, CGRectGetWidth(self.view.bounds),kButtonViewHeight);
 #define kButtonWidth 80
    self.cancelButton.frame = CGRectMake(5, CGRectGetMinY(self.buttonBackgroundView.frame), kButtonWidth, kButtonViewHeight);
    self.confirmButton.frame = CGRectMake(self.view.frame.size.width-kButtonWidth, CGRectGetMinY(self.buttonBackgroundView.frame), kButtonWidth, kButtonViewHeight);
    
     self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    self.scrollView.frame = self.view.bounds;
    
    //overlayView
     CGFloat width = self.view.bounds.size.width;
    CGFloat height = width/self.ratioOfWidthAndHeight;
    BOOL isBaseOnWidth = YES;
    if (height>self.view.bounds.size.height) {
         height = self.view.bounds.size.height;
        width = height*self.ratioOfWidthAndHeight;
        isBaseOnWidth = NO;
    }
    self.overlayView.frame = CGRectMake(0, 0, width, height);
    self.overlayView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
     if (isBaseOnWidth) {
         self.topBlackView.frame = CGRectMake(0, 0, width, CGRectGetMinY(self.overlayView.frame));
        self.bottomBlackView.frame = CGRectMake(0, CGRectGetMaxY(self.overlayView.frame), width, CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.overlayView.frame));
    }else{
         self.topBlackView.frame = CGRectMake(0, 0, CGRectGetMinX(self.overlayView.frame), height);
        self.bottomBlackView.frame = CGRectMake(CGRectGetMaxX(self.overlayView.frame),0, CGRectGetWidth(self.view.bounds)-CGRectGetMaxX(self.overlayView.frame), height);
    }
    
     [self adjustImageViewFrameAndScrollViewContent];
}

#pragma mark - adjust image frame and scrollView's  content
/***
 Method Name : adjustImageViewFrameAndScrollViewContent
 Input Parameter : nil
 Return Type : nil
 Method Description :this function used to  automatically adjust imageview in Scrollview
 ***/
- (void)adjustImageViewFrameAndScrollViewContent
{
    CGRect frame = self.scrollView.frame;
    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        
        if (frame.size.width<=frame.size.height) {
             CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        }else{
            CGFloat ratio = frame.size.height/imageFrame.size.height;
            imageFrame.size.width = imageFrame.size.width*ratio;
            imageFrame.size.height = frame.size.height;
        }
        
        self.scrollView.contentSize = frame.size;
        
        BOOL isBaseOnWidth = [self isBaseOnWidthOfOverlayView];
        if (isBaseOnWidth) {
            self.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetMinY(self.overlayView.frame), 0, CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.overlayView.frame), 0);
        }else{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, CGRectGetMinX(self.overlayView.frame), 0, CGRectGetWidth(self.view.bounds)-CGRectGetMaxX(self.overlayView.frame));
        }
        
        self.imageView.frame = imageFrame;
        
         CGFloat minScale = self.overlayView.frame.size.height/imageFrame.size.height;
        CGFloat minScale2 = self.overlayView.frame.size.width/imageFrame.size.width;
        minScale = minScale>minScale2?minScale:minScale2;
        
        self.scrollView.minimumZoomScale = minScale;
        self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale*3<2.0f?2.0f:self.scrollView.minimumZoomScale*3;
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
        
         if (isBaseOnWidth) {
            CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height)?
            (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5 : 0.0;
            self.scrollView.contentOffset = CGPointMake(0, -offsetY);
        }else{
            CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)?
            (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
            self.scrollView.contentOffset = CGPointMake(-offsetX,0);
        }
    }else{
        frame.origin = CGPointZero;
        self.imageView.frame = frame;
         self.scrollView.contentSize = self.imageView.frame.size;
        
        self.scrollView.minimumZoomScale = 1.0f;
        self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale;
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    }
}


#pragma mark - UIScrollViewDelegate
/***
 Method Name : viewForZoomingInScrollView
 Input Parameter : UIScrollView
 Return Type : UIView
 Method Description : pinch to zoom the imageView
 ***/
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageView;
}

@end

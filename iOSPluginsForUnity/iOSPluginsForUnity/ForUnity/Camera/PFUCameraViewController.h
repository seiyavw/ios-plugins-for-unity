//
//  PFUCameraViewController.h
//  PFU 
//
//  Created by Seiya Sasaki on 2014/06/30.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PFUCameraViewHiddenBlock)(NSString *savedPath);

@interface PFUCameraViewController : UIViewController

@property (nonatomic, copy) PFUCameraViewHiddenBlock hiddenBlock;

- (void)show;

@end

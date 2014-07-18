//
//  PFUInputViewController.h
//  PFU
//
//  Created by Seiya Sasaki on 2014/07/15.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PFUInputShouldHideBlock)(NSString *text);
typedef NS_ENUM(uint8_t, PFUInputType) {
    PFUInputTypeEmail    = 1,
    PFUInputTypePassword
};

@interface PFUInputViewController : UIViewController

@property (nonatomic, copy) PFUInputShouldHideBlock shouldHideBlock;


- (void)setupKeyboard:(PFUInputType)inputType text:(NSString *)text length:(short)length;
- (void)showView;
- (void)hideView;

@end

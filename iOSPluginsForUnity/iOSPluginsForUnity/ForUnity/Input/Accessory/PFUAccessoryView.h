//
//  PFUAccessoryView.h
//  PFU 
//
//  Created by Seiya Sasaki on 2014/07/15.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFUAccessoryView : UIView

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UITextField *textField;

+ (PFUAccessoryView *)create;

@end

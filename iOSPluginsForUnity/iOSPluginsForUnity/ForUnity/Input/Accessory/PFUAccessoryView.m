//
//  PFUAccessoryView.m
//  PFU 
//
//  Created by Seiya Sasaki on 2014/07/15.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import "PFUAccessoryView.h"

@implementation PFUAccessoryView

+ (PFUAccessoryView *)create {
    
    return [[PFUAccessoryView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 80.f)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor blueColor];
    
    UIView *textWrapView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 40.f)];
    textWrapView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 1.0f)];
    lineView.backgroundColor = [UIColor colorWithRed:0.682 green:0.702 blue:0.745 alpha:1.0]; // gray line
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10.f, 11.f, 300.f, 20.f)];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textWrapView addSubview:lineView];
    [textWrapView addSubview:textField];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(260.f, 42.f, 60.f, 38.f);
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"完了" forState:UIControlStateNormal];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0.f, 42.f, 110.f, 38.f);
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"キャンセル" forState:UIControlStateNormal];
    
    [self addSubview:textWrapView];
    [self addSubview:doneButton];
    [self addSubview:cancelButton];
    
    _textField = textField;
    _doneButton = doneButton;
    _cancelButton = cancelButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

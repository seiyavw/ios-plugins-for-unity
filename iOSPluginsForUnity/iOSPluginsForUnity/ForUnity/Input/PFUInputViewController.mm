//
//  PFUInputViewController.m
//  PFU
//
//  Created by Seiya Sasaki on 2014/07/15.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import "PFUInputViewController.h"
#import "PFUAccessoryView.h"

@interface PFUInputViewController () <UITextFieldDelegate>

@end

@implementation PFUInputViewController {
    UITextField *_dummyTextField;
    PFUAccessoryView *_accessoryView;
    short _maxLength;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dummyTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 40.f)];
    _dummyTextField.returnKeyType = UIReturnKeyDone;
    _dummyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _dummyTextField.alpha = 0.f;
    _dummyTextField.delegate = self;
    
    [self.view addSubview:_dummyTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupKeyboardWithType:(PFUInputType)inputType
{
    // setup accessory view
    _accessoryView = [PFUAccessoryView create];
    [_accessoryView.doneButton addTarget:self action:@selector(didTapDoneButton) forControlEvents:UIControlEventTouchUpInside];
    [_accessoryView.cancelButton addTarget:self action:@selector(didTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    _accessoryView.textField.delegate = self;
    
    switch (inputType) {
        case PFUInputTypeEmail: {
            _dummyTextField.keyboardType = _accessoryView.textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        }
        case PFUInputTypePassword: {
            
            _dummyTextField.secureTextEntry = _accessoryView.textField.secureTextEntry = YES;
            _dummyTextField.clearsOnBeginEditing = _accessoryView.textField.clearsOnBeginEditing = NO;
            _dummyTextField.keyboardType = _accessoryView.textField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        }
        default:
            break;
    }

}

- (void)setupKeyboard:(PFUInputType)inputType text:(NSString *)text length:(short)length
{
    [self setupKeyboardWithType:inputType];
    _accessoryView.textField.text = text;
    _maxLength = length;
    
}

- (void)showView
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window == nil) return;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = CGRectMake(0.f, 0.f, 0.f, 0.f);
    [window addSubview:self.view];
    
    [self showKeyboard];
}

- (void)hideView
{
    [self hideKeyboardIfNeeded];
    [self.view removeFromSuperview];
}

- (void)showKeyboard
{
    [_dummyTextField becomeFirstResponder];
    [_accessoryView.textField becomeFirstResponder];
}

- (void)hideKeyboardIfNeeded
{
    if ([_dummyTextField isFirstResponder]) {
        [_dummyTextField resignFirstResponder];
    }
    if ([_accessoryView.textField isFirstResponder]) {
        [_accessoryView.textField resignFirstResponder];
    }
}

- (void)didTapDoneButton
{
    if (self.shouldHideBlock) {
        // send value
        self.shouldHideBlock(_accessoryView.textField.text);
    }
    [self hideView];
}

- (void)didTapCancelButton
{
    if (self.shouldHideBlock) {
    
        self.shouldHideBlock(nil);
    }
    [self hideView];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *text = [textField.text mutableCopy];
    
    [text replaceCharactersInRange:range withString:string];
    
    return (_maxLength == 0) || ([text length] <= _maxLength);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _dummyTextField) {
        textField.inputAccessoryView = _accessoryView;
        _dummyTextField.delegate = nil; // no need any more
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.shouldHideBlock) {
        self.shouldHideBlock(_accessoryView.textField.text);
    }
    [self hideView];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

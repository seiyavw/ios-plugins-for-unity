//
//  PFUCameraViewController.m
//  PFU
//
//  Created by Seiya Sasaki on 2014/06/30.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import "PFUCameraViewController.h"

@interface PFUCameraViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIAlertViewDelegate>

@end

@implementation PFUCameraViewController {
    UIImagePickerController *_picker;
    UIView *_loadingView;
}

static const NSInteger kPFUErrorAlert = 1001;
static const NSInteger kPFUSavedAlert = 1002;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)showLoadingView
{
    if (_loadingView == nil) {
    
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8f];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.center = _loadingView.center;
        [indicator startAnimating];
        [_loadingView addSubview:indicator];
        
        [self.view addSubview:_loadingView];
    }
}

- (void)hideLoadingView
{
    if (_loadingView != nil) {
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
}

- (void)addPicker
{
    if (_picker == nil) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self.view addSubview:picker.view];
        _picker = picker;
    }
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window == nil) return;
    
    [self addPicker];
    
    [self.view setFrame:CGRectMake(0.f, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, self.view.frame.size.height)];;
    [window addSubview:self.view];
    
    __weak typeof (self) weakSelf = self;
    
    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf.view setFrame:CGRectMake(0.f, 0.f, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height)];
    } completion:nil];
}

- (void)removePicker
{
    if (_picker != nil) {
        
        [_picker.view removeFromSuperview];
        _picker = nil;
    }
}

- (void)hideBySuccess {
    
    __weak typeof (self) weakSelf = self;
    
    [self hideWithCompletion:^(BOOL finished) {
        
        [weakSelf removePicker];
        [weakSelf.view removeFromSuperview];
        
        if (weakSelf.hiddenBlock) {
            weakSelf.hiddenBlock([self photoFilePath]);
        }
    }];
}

- (void)hide {
    
    __weak typeof (self) weakSelf = self;
    
    [self hideWithCompletion:^(BOOL finished) {
        
        [weakSelf removePicker];
        [weakSelf.view removeFromSuperview];
        
        if (weakSelf.hiddenBlock) {
            weakSelf.hiddenBlock(nil);
        }
    }];
}

- (void)hideWithCompletion:(void (^)(BOOL finished))completion
{
    __weak typeof (self) weakSelf = self;
    
    [UIView animateWithDuration:0.25f delay:0.25f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [weakSelf.view setFrame:CGRectMake(0.f, [UIScreen mainScreen].bounds.size.height, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height)];
        
    } completion:completion];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self showLoadingView];
    
    UIImage *takenImage = (UIImage *)[info objectForKey: UIImagePickerControllerOriginalImage];
    
    UIImageWriteToSavedPhotosAlbum(takenImage, self, @selector(finishPhotoSaved:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self hide];
}

- (void)finishPhotoSaved:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if (error == nil) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
            BOOL saved = [imageData writeToFile:[self photoFilePath] atomically:YES];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self hideLoadingView];
                
                if (saved) {
                    
                    [self showSavedAlert];
                    
                } else {
                    
                    [self showErrorAlert];
                }
            });
            
            
        } else {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self hideLoadingView];
                [self showErrorAlert];
            });
        }
    });
    
    
}

#pragma mark - private - Alert

- (void)showSavedAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存"
                                                        message:@"写真を保存しました"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = kPFUSavedAlert;
    [alertView show];
}

- (void)showErrorAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"写真の保存に失敗しました。"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = kPFUErrorAlert;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (alertView.tag) {
        case kPFUErrorAlert: {
            if (buttonIndex == 0) {
                [self hide];
            }
            break;
        }
        case kPFUSavedAlert: {
            if (buttonIndex == 0) {
                [self hideBySuccess];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - private - path helper

- (NSString *)photoFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *tempPath = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"mysaved_photo"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:tempPath]) {
        [fileManager createDirectoryAtPath:tempPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    
    NSString *filePath = [tempPath stringByAppendingPathComponent:@"/taken_photo.jpg"];
    return filePath;
}

@end

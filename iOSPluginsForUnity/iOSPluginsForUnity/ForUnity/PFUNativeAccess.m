//
//  PFUNativeAccess.m
//  PFU 
//
//  Created by Seiya Sasaki on 2014/06/17.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import "PFUNativeAccess.h"
#import "PFUMovieDisplayController.h"
#import "PFUCameraViewController.h"
#import "PFUInputViewController.h"

static PFUMovieDisplayController *movieDisplayController;
static PFUCameraViewController *cameraViewController;
static PFUInputViewController *inputViewController;

#pragma mark - Status Bar

void show_status_bar() {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

};

void hide_status_bar() {

    [[UIApplication sharedApplication] setStatusBarHidden:YES];

};

void set_status_bar_white() {

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
};

void set_status_bar_black() {

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
};

#pragma mark - Movie View

/**
 * initialize movie view
 */
void initialize_movie_view(char* url) {
    
    if (movieDisplayController == nil) {
        
        NSString *encodedURLString = [NSString stringWithCString:url encoding:NSASCIIStringEncoding];
        NSURL *movieURL = [NSURL URLWithString:encodedURLString];
        
        movieDisplayController = [[PFUMovieDisplayController alloc] init];
        movieDisplayController.movieURL = movieURL;
        movieDisplayController.stateChangedBlock = ^(PFUMovieControllerState state) {
            
            switch (state) {
                case PFUMovieControllerDidFinishPlaying: {
                    
                    hide_movie_view();
                    break;
                }
                default:
                    break;
            }
        };
    }
}

/**
 * show movie view and play automatically
 */
void show_movie_view() {
    
    if (movieDisplayController != nil) {
        
        [movieDisplayController showAnimated:YES completion:nil];
    }
}

/**
 * hide movie view, and then controller will be released.
 * Therefore, every time you need a movie view, you need to initialize it before showing.
 */
void hide_movie_view() {
    
    if (movieDisplayController != nil) {
        
        [movieDisplayController stop];
        [movieDisplayController hideAnimated:YES completion:^(BOOL finished) {
            movieDisplayController = nil;
        }];
    }
}

#pragma mark - Camera View

void show_camera_view() {
    
    if (cameraViewController == nil) {
        cameraViewController = [[PFUCameraViewController alloc] init];
        cameraViewController.hiddenBlock = ^(NSString *savedPath) {
            
#ifdef WITH_UNITY
            UnityPause(false);
            if (savedPath) {
                UnitySendMessage("", "PFUTakePictureFinish", (char *)[savedPath UTF8String]);
            }
#endif
            
            cameraViewController = nil;
        };
        
#ifdef WITH_UNITY
        UnityPause(true);
#endif
        [cameraViewController show];
    }
}

#pragma mark - Input View

void show_input_view(uint8_t type, char *value, short length) {
    
    if (inputViewController != nil) {
        // if called while other keyboard is shown, hide it.
        hide_input_view();
    }
    
    if (inputViewController == nil) {
        inputViewController = [[PFUInputViewController alloc] init];
        NSString *text = [NSString stringWithCString:value encoding:NSASCIIStringEncoding];
        [inputViewController setupKeyboard:type text:text length:length];
        [inputViewController showView];
        
        inputViewController.shouldHideBlock = ^(NSString *text) {
            if (text != nil) {
#ifdef WITH_UNITY
                UnitySendMessage("", "PFUTextInputFinish", (char *)[text UTF8String]);
#endif
            }
            hide_input_view();
        };
    }
}

void hide_input_view() {
    
    if (inputViewController != nil) {
        [inputViewController hideView];
        inputViewController = nil;
    }

}
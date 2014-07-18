//
//  PFUMovieDisplayController.h
//  PFU
//
//  Created by Seiya Sasaki on 2014/06/17.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PFUMovieControllerState) {
    PFUMovieControllerDidFinishPlaying = 0
};


typedef void(^PFUMovieControllerStateChanged)(PFUMovieControllerState state);

@interface PFUMovieDisplayController : UIViewController

@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, copy) PFUMovieControllerStateChanged stateChangedBlock;

- (void)showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)hideAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

- (void)play;
- (void)stop;

@end

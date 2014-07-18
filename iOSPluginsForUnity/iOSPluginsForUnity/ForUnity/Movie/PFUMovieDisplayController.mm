//
//  PFUMovieDisplayController.m
//  PFU
//
//  Created by Seiya Sasaki on 2014/06/17.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import "PFUMovieDisplayController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PFUMovieDisplayController ()

@end

@implementation PFUMovieDisplayController
{
    MPMoviePlayerController *_movieController;
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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupMovieController];
    [self registerNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)setupMovieController
{
    MPMoviePlayerController *movieController = [[MPMoviePlayerController alloc] initWithContentURL:self.movieURL];
    movieController.view.frame = self.view.frame;
    movieController.controlStyle = MPMovieControlStyleFullscreen;
    _movieController = movieController;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:movieController.view];
    });
}

- (void)showAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window == nil) return;
    
    if (animated) {
        
        self.view.alpha = 0.f;
        
        [window addSubview:self.view];
        
        __weak typeof (self) weakSelf = self;
        [UIView animateWithDuration:0.33 animations:^{
            
            weakSelf.view.alpha = 1.f;
            
        } completion:^(BOOL finished) {
            
            [weakSelf play];
            
            if (completion) {
                completion(finished);
            }
        }];
        
    } else {
        
        [window addSubview:self.view];
        [self play];
    }
}

- (void)hideAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.33 animations:^{
        
        weakSelf.view.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [weakSelf.view removeFromSuperview];
        
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)registerNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    
}

-(void)playbackFinished:(NSNotification*)aNotification
{
    NSInteger reason = [[aNotification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason) {
        case MPMovieFinishReasonUserExited:
        case MPMovieFinishReasonPlaybackEnded:
        case MPMovieFinishReasonPlaybackError: {
            
            if (self.stateChangedBlock) {
                self.stateChangedBlock(PFUMovieControllerDidFinishPlaying);
            }
        
            break;
        }
        default: {
            break;
        }
    }
}

-(void)willExitFullscreen:(NSNotification*)aNotification
{
    
    NSNumber *reason = [aNotification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if ([reason intValue] == MPMovieFinishReasonUserExited) {
        
        [_movieController stop];
        
        if (self.stateChangedBlock) {
            self.stateChangedBlock(PFUMovieControllerDidFinishPlaying);
        }
    }
}

- (void)play {
    
    [_movieController play];
}

- (void)stop {
    
    [_movieController stop];
}

- (void)dealloc
{
    [self removeNotifications];
    _movieController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

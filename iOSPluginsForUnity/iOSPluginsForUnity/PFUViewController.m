//
//  PFUViewController.m
//  iOSPluginsForUnity
//
//  Created by Seiya Sasaki on 2014/07/18.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import "PFUViewController.h"
#import "PFUNativeAccess.h"

@interface PFUViewController ()

@end

@implementation PFUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapEmailKeyboardButton:(id)sender {
    show_input_view(1, "google@yahoo.co.jp", 0);
}
- (IBAction)didTapPassKeyboardButton:(id)sender {
    show_input_view(2, "0000", 10);
}
- (IBAction)didTapCameraButton:(id)sender {
    show_camera_view();
}
- (IBAction)didTapMovieButton:(id)sender {
    char *url = "http://yhk.minibird.jp/honttoni/video/uchiage.mp4";
    initialize_movie_view(url);
    show_movie_view();

}
- (IBAction)didTapStatusBarShowButton:(id)sender {
    show_status_bar();
}
- (IBAction)didTapStatusBarHideButton:(id)sender {
    hide_status_bar();
}

@end

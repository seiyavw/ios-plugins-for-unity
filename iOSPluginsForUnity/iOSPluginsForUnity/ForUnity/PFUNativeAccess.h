//
//  PFUNativeAccess.h
//  PFU
//
//  Created by Seiya Sasaki on 2014/06/17.
//  Copyright (c) 2014年 corleonis. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __cplusplus
extern "C" {
#endif
    /**
     * iOS status bar
     */
    void show_status_bar();
    void hide_status_bar();
    void set_status_bar_white();
    void set_status_bar_black();
    
    /**
     * iOS Movie View
     */
    void initialize_movie_view(char* url);  // Initialize movie view. Everytime showing movie, needs to call this beforehand.
    void show_movie_view();                 // Show movie view and play automatically
    void hide_movie_view();                 // Hide movie view (If playing, stop movie in this function)
    
    /**
     * iOS Camera View
     */
    void show_camera_view();
    
    /**
     * iOS Input View
     */
    // type, value, length
    // type- 1:email 2:password
    void show_input_view(uint8_t type, char*value, short length);
    void hide_input_view();
    
#ifdef __cplusplus
}
#endif

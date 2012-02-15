//
//  mmReader.h
//  circus-one
//
//  Created by colman on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"
#import <MediaPlayer/MPMoviePlayerController.h>

#define kAccelerometerFrequency     40

@interface mmReader : UIViewController <UIAccelerometerDelegate> {
    BOOL transitioning;
    
    MPMoviePlayerController *videoPlayer;
    
    // The scrollView for the menu
    UIScrollView * scrollView_doc ;
    
    UIScrollView * scrollViewB;
    
    // The ImageView that will be changed
    // upon browsing and responding to gestures
    UIImageView * docView;
    
    UIImageView * temp;
    
    UIImage * docI;
    
    UIImage * tempI;
    
    int height;
    
    // postion of view
    float scrollPosition;
    
     NSArray  * buttons;
    
    // pdf by index from hardcoded strings
    int pdfIndex;
    
    // name of current file
    NSString * nameOfFile;
    
    //////////////////////////////////////////////
    UISwipeGestureRecognizer *swipeLeftRecognizer;
    UISegmentedControl *segmentedControl;
    /////////////////////////
    
    CGPoint touchPoint;
    
    Bar * bar;
    
    UIWebView * blog;
    
    UIButton * videoButton;
    
    CGRect landscapeVideoFrame_97;
    CGRect portraitVideoFrame_97;
    CGRect landscapeVideoFrame_2;
    CGRect portraitVideoFrame_2;
    CGRect landscapeVideoFrame_0;
    CGRect portraitVideoFrame_0;
}

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

-(void) getNextIndex;
-(void) getPreviousIndex;
-(void) playVideo;
-(void) setVideoFrame;

// document string name is set
-(void) setDocument:(int) docIndex;

-(void) setScrollPosition:(float)var;

@end










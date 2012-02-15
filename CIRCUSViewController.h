//
//  CIRCUSViewController.h
//  CIRCUS
//
//  Created by colman on 27.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mmReader.h"
#import "Player.h"
#import "VidPlayer.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#define kAccelerometerFrequency     40

@interface CIRCUSViewController : UIViewController  {
    
    ////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////
    // core elements main views etc
    // The scrollView for the menu
    ////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////
    UIScrollView *scrollView ;
    
    // preview.pdf UIView
    UIImageView * menuView;
    
    UIImage * menu;
    
    UIImageView * welcomeScreen;
    UIView * container;
    
    UIView * buttonContainer;
    
    UIImage * welcome;
    UIButton * buttons[100];
    
    
    CGRect portFrame[100];
    CGRect landFrame[100];
    
    @public mmReader * mmRead;

    ////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////
    // extras , rrbtn, video , turn done
    ////////////////////////////////////////////////////////////
    
    UIButton * rrbtn;
    Player * play;
    MPMoviePlayerController *videoPlayer;
    VidPlayer * p;
    
    CGPoint deviceTilt;
    
    bool alreadyDone;
    bool turn;
    float portFrameLocations[100][2];
    //+- 137
    
    float factor;
}

-(void) pleaseInit;
-(void) arrangeButtonsLand;
-(void) arrangeButtonsPort;
-(void) stateOfDevice:(BOOL)horiz:(BOOL)vert;
-(void) rotateWithState:(BOOL)horiz:(BOOL)vert;


@end





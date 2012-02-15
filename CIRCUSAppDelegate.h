//
//  CIRCUSAppDelegate.h
//  CIRCUS
//
//  Created by colman on 27.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CIRCUSViewController;

@interface CIRCUSAppDelegate : NSObject <UIApplicationDelegate> {
    
    
    
    CIRCUSViewController * circus;
    
    UIViewController * welcomeScreen;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CIRCUSViewController *viewController;

-(void) prepareNames;

@end

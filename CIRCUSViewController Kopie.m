//
//  CIRCUSViewController.m
//  CIRCUS
//
//  Created by colman on 27.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CIRCUSViewController.h"
#import "PrepImage.h"

@implementation CIRCUSViewController

extern bool horiz;
extern bool vert;

extern bool localHorizVariable;
extern bool localVertVariable;

float imageWidth;
float imageHeight;
int count=0;
CGFloat _height;

int entries[3];

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        factor = .75;
        mmRead = [[mmReader alloc] init];
        play   = [[Player alloc] init];
        p = [[VidPlayer alloc] init];
        
        entries[0] = 0;
        entries[1] = 2;
        entries[2] = 7;
//         int doubleDigits[10] = {1,2,3,4,5,6,7,8,9,10};
        
        [self setupMenuBackground];
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated {
//     [self.navigationController setNavigationBarHidden:NO animated:animated];
}

int readings;
double values[];
//extern float * scrollPositions_d[];
//   NSLog(@"external float %f", scrollPositions_d[0]);

NSMutableArray * myArray;
// UIAccelerometerDelegate method, called when the device accelerates.
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    // Update the accelerometer graph view

    if (readings == 10) {
        readings = 0;
        [self calcVolatility:values];
//        values[10] = {0,0,0,0,0,0,0,0,0,0};
    }
    if (readings < 10) {
        values[readings] = acceleration.y;
//        myArray[readings] = acceleration.y; 
//        [myArray objectAtIndex:readings] = acceleration.y;
//        [myArray replaceObjectAtIndex:readings withObject:acceleration.y];
        readings++;
    }
//    NSLog(@"X: %f  +   Y: %f   +  Z:  %f",acceleration.x,acceleration.y,acceleration.z);
}



-(void) calcVolatility:(float *)values {
    float frac = 0.1;
    float res1;
    float res3;
    
    for (int j=0; j<10; j++) {

//        NSLog(@"external float %f", values[j]);
//        NSLog(@"%f",values[j]);
//        NSLog(@"%d",myArray[j]);
        float temp = (float)values[j];
        res1 = res1 + (j - temp)*(j - temp);
        if (values[j] < 0) {
            values[j] = -1*values[j];
        }
        res3 += values[j];


    }
//    NSLog(@"direct sum %f", res3);
    float res2 = res1 * frac;
//    NSLog(@"volatility %f",res2);
    
    if (res2 > 40 ) {
        
        int n = (random() % 100);
        [mmRead setDocument:n];
        [self.navigationController pushViewController:mmRead transition:6];
    }
    
//    if (res3 > 10 || res3 < -8) {
//        int n = (random() % 100);
//        [mmRead setDocument:n];
//        [self.navigationController pushViewController:mmRead transition:6];
//
//    }
    
}

- (void) viewDidLoad {
    


    
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin = CGPointZero;
    
    //////////////////////////////////////////////////
    // preparing UIScrollView
    // with documentI as an image
    //////////////////////////////////////////////////
    float w = 768.0;
    
    scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, 1024)] autorelease] ;
    scrollView.contentSize = CGRectMake(0, 0, 1024, menu.size.height).size;
    menuView.center = CGPointMake(scrollView.contentSize.width * 0.5, 
                                   scrollView.contentSize.height * 0.5);
    
    [scrollView addSubview:menuView];
    

    
    
    
    // horizontal space
    int space = 100;
    
    // vertical space
	int spacev = 35;
    
    // including fake buttons
    int buttonNumber = 100;
    
    // create all the buttons that are to be added to the main menu
    // the button.tag property will
    // be used later to find out which ones are supposed to work
    // are which ones are not
    
    int k = 0; // track the buttons with the tags for the listerner
	for (int i=0; i<buttonNumber; i++) {
		space = 0;
		for (int j=0; j<3; j++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            // just about show where the button is
            // only visible to the trained eye
            [button setAlpha:0.02];
            
            // position match for the buttons over the pics in the 
            // preview image
            CGRect frame = CGRectMake(space + 165, spacev , 220.0 , 150.0 );
            button.frame = frame;
            int sum = i + j;
            button.tag = k;
            k++;
            
            // add the action to push the reader
            // later it will be found out whichever pdf should be loaded
			[button addTarget:self action:@selector(loadAndMove:) forControlEvents:UIControlEventTouchUpInside];
			[scrollView addSubview:button];
//            [button release];
			space = space + 245;
		}
        // we moved accross already one row
        // now move down to the next level 
        spacev	= spacev + 170;
	}

    [self.view addSubview:scrollView];
//        [scrollView addSubview:rrbtn];
    
    if (!alreadyDone) {
        scrollView.hidden = YES;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // just about show where the button is
        // only visible to the trained eye
        [button setAlpha:0.7];
        
        // position match for the buttons over the pics in the 
        // preview image
        CGRect frame = CGRectMake(650, 865 , 85 , 35 );
        button.frame = frame;
        UILabel * label = [[UILabel alloc] init];
        label.text = @"Continue";
        button.accessibilityLabel = @"Continue";
        [button setTitle:label.text forState:0];
        [button addTarget:self action:@selector(goAway:) forControlEvents:UIControlEventTouchUpInside];


        
        if(!alreadyDone) {
            container = [[UIView alloc] initWithFrame:self.view.frame];
            welcomeScreen = [[UIImageView alloc] initWithFrame:self.view.frame];
//        welcomeScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 200)];
        
            
            
            ///////
            
            if(!alreadyDone) {
//                welcomeScreen = [[UIView alloc] initWithFrame:self.view.frame];
                //        welcomeScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 200)];
                
                PrepImage *pi = [[PrepImage alloc] init];
                welcome = [pi prepareImage:@"welcome1C.pdf"];
                welcomeScreen = [[UIImageView alloc] initWithImage:welcome];                
                welcomeScreen.frame = CGRectMake(0, -10 , 768 , 1024.0 );

                welcomeScreen.backgroundColor = [UIColor redColor];
               [pi release];
                
                welcomeScreen.image = welcome;

                [container addSubview:welcomeScreen];
                [container  addSubview:button];
                [self.view addSubview:container];
                
                alreadyDone = true;
                
            }
//        self.view = welcomeScreen;
//            [self.view addSubview:welcomeScreen];
            alreadyDone = true;
            turn = false;
        }
    }
}

- (IBAction) goAway:(id) sender {
    scrollView.hidden = NO;
    
    container.hidden = YES;
    
//    [container removeFromSuperview];
//    [container autorelease];
//    [welcomeScreen autorelease];
//    [welcome autorelease];
//    self.view = scrollView;
//    welcomeScreen.hidden = YES;
    welcomeScreen.backgroundColor = [UIColor blueColor];
    turn = true;
    
//    [welcomeScreen removeFromSuperview];
}

- (void)viewDidUnload
{
//    [self rotateImage_menu];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

        
    
    // rotations for the menu after the instruction dialog has been shown
    if (turn) {
//        [self rotateImage_menu]; 

//        [self performSelectorOnMainThread:@selector(rotateImage_menu)];
//        [menuView setAutoresizingMask:UIViewContentModeScaleAspectFit];
//        [menuView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//
////        UIViewContentModeScaleAspectFit
//        [scrollView setAutoresizingMask:UIViewAutoresizingNone];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        float screenHeight = screenBounds.size.height;
        float screenWidth = screenBounds.size.width;
 
        if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
            (interfaceOrientation == UIInterfaceOrientationLandscapeRight)) 
        {
            //        [scrollView performSelectorOnMainThread:@selector(invoke)];
            menuView.frame = CGRectMake(0, 0, screenHeight, _height);
            scrollView.frame =CGRectMake(0, 0, screenHeight, screenWidth);
            scrollView.contentSize = CGRectMake(0, 0, screenHeight, _height*1.01).size;
            
        } else {
            menuView.frame = CGRectMake(0, 0, screenHeight + 20, _height);
            scrollView.frame =CGRectMake(-140, 0, screenHeight, screenHeight);
            scrollView.contentSize = CGRectMake(0, 0, screenWidth, _height*1.008).size;
        }
        
//        if ((interfaceOrientation == UIDeviceOrientationLandscapeLeft) || 
//            (interfaceOrientation == UIDeviceOrientationLandscapeRight)) 
//        {
//            //        [scrollView performSelectorOnMainThread:@selector(invoke)];
//            menuView.frame = CGRectMake(0, 0, 1024, _height);
//            scrollView.frame =CGRectMake(0, 0, 1024, 768);
//            scrollView.contentSize = CGRectMake(0, 0, 1024, _height*1.01).size;
//            
//        } else {
//            menuView.frame = CGRectMake(0, 0, 1048, _height);
//            scrollView.frame =CGRectMake(-140, 0, 1024, 1024);
//            scrollView.contentSize = CGRectMake(0, 0, 768, _height*1.008).size;
//        }
        
        
        return YES;
    }
    
    
    // auto rotates for the instructions correctly
    
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)  {
        return YES;
    }
    else {
        return NO;
    }
//    return NO;

}

// sets preview.pdf as the background image object of the root controller



-(void) viewDidAppear:(BOOL)animated {
//    [self rotateImage_menu];
    float sp = (int)scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(0,sp + 1)  animated: YES];
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"menuvideo.m4v" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    ////        
    videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    videoPlayer.view.frame = CGRectMake(410, 5475,220, 150  );  
    
    
    //        //    videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
    
    videoPlayer.repeatMode = MPMovieRepeatModeOne;
    //        [videoPlayer setFullscreen:YES];
    //    [[videoPlayer ] setVolume:0.0];
    [videoPlayer play];
    
    
    ///
    UIButton * rrbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // just about show where the button is
    // only visible to the trained eye
    [rrbtn setAlpha:0.02];
    
    // position match for the buttons over the pics in the 
    // preview image
    CGRect frame = CGRectMake(410, 5475 , 220.0 , 150.0 );
    rrbtn.frame = frame;
    rrbtn.tag = 97;
    
    // add the action to push the reader
    // later it will be found out whichever pdf should be loaded
    [rrbtn addTarget:self action:@selector(loadAndMove:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:videoPlayer.view];
    [scrollView addSubview:rrbtn];

}

// called after the back button is pushed
-(void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [self rotateImage_menu];
    
    if (([self interfaceOrientation] == UIDeviceOrientationLandscapeLeft) || 
        ([self interfaceOrientation] == UIDeviceOrientationLandscapeRight)) 
    {
        //        [scrollView performSelectorOnMainThread:@selector(invoke)];
        menuView.frame = CGRectMake(0, 0, 1024, _height);
        scrollView.frame =CGRectMake(0, 0, 1024, 768);
        scrollView.contentSize = CGRectMake(0, 0, 1024, _height*1.01).size;
        
    } else {
        menuView.frame = CGRectMake(0, 0, 1048, _height);
        scrollView.frame =CGRectMake(-140, 0, 1024, 1024);
        scrollView.contentSize = CGRectMake(0, 0, 768, _height*1.008).size;
    }
    
    [mmRead release];
    mmRead = [[mmReader alloc] init];
    

//    [self rotateImage_menu];
}



//-(void) stateOfDevice:(BOOL)horiz:(BOOL)vert {
//    if (horiz) {
//
//        scrollView.contentSize = CGRectMake(0, 0, 1024, _height*1.01).size;
//   		scrollView.frame =CGRectMake(0, 0, 1024, 768);
//        menuView.frame = CGRectMake(0, 0, 1024, _height);
//
//
//    }
//    if (vert) {
//        scrollView.contentSize = CGRectMake(0, 0, 768, _height*1.008).size;
//        scrollView.frame =CGRectMake(-140, 0, 1024, 1024);
//        menuView.frame = CGRectMake(0, 0, 1048, _height);
////        scrollView.frame =CGRectMake(-140, 0, 1024, 1024);
//        // shake crash point
//    }
//}

-(void) callmmRead:(BOOL)horiz:(BOOL)vert {
    [mmRead rotateImage];
}

-(void) setupMenuBackground {
    PrepImage *pi = [[PrepImage alloc] init];
    menu = [pi prepareImage:@"preview.pdf"];
    _height = menu.size.height;
    imageWidth = menu.size.width;
    imageHeight = menu.size.height;
    menuView = [[UIImageView alloc] initWithImage:menu];
    [pi release];
}

// bind to the correct buttons and push the next VC with the documentI
- (IBAction) loadAndMove:(id) sender {
    UIButton *button = sender;
    int tag = button.tag;
    NSLog(@"Button Number Pressed %d ", button.tag);
    
   
    
    if ( ( tag ==  6) ||( tag ==  3) ||( tag ==  12) || ( tag ==  16) || ( tag ==  20) || ( tag ==  24)  || ( tag ==  28) || ( tag ==  40) || ( tag ==  44) || ( tag ==  45) || ( tag ==  53) || ( tag ==  54) || ( tag ==  59) || ( tag ==  61) || ( tag ==  66) || ( tag == 68) || ( tag ==  70) || ( tag ==  76) || ( tag ==  78) || ( tag ==  82) || ( tag ==  86) || ( tag ==  91) || ( tag ==  96) || ( tag == 98) || ( tag == 1) || ( tag == 5) || ( tag == 8) || ( tag == 22) || ( tag == 36) || ( tag == 51) || ( tag == 64) || ( tag == 80) || ( tag == 88) )
    {
        NSLog(@"does it work? %d ", button.tag);
    }
    else 
    {
        NSLog(@"%f" ,button.frame.origin.x);
        NSLog(@"%f" ,button.frame.origin.y);

        [mmRead setDocument:button.tag];
        [self.navigationController pushViewController:mmRead transition:6];
    }
    
}

@end


//    if (localHorizVariable) {
//        scrollView.frame =CGRectMake(0, 0, 1024, 768);
//        scrollView.contentSize = CGRectMake(0, 0, 1024, _height*1.01).size;
//        
//        menuView.frame = CGRectMake(0, 0, 1024, _height);
//    }
//    if (localVertVariable) {
//        //        scrollView.frame =CGRectMake(-140, 0, 1024, 1024);
//        scrollView.frame =CGRectMake(-140, 0, 1024, 1024);
//        scrollView.contentSize = CGRectMake(0, 0, 768, _height*1.008).size;
//        
//        menuView.frame = CGRectMake(0, 0, 1048, _height);
//    }
//    [self stateOfDevice];

//    return YES;


//        NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"redridinghood.mp4" ofType:nil];
//        NSURL *url = [NSURL fileURLWithPath:urlStr];
//////        
//        videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
//        videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
//        
//        [self.view addSubview:videoPlayer.view];
//        //    videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
//        //    videoPlayer.repeatMode = MPMovieRepeatModeOne;
//        [videoPlayer setFullscreen:YES];
//        [videoPlayer play];

//-(void) rotateImage_menu {
//    // without this code the menu sometimes after coming back
//    // isn't in the right position
//    menuView.frame = CGRectMake(0, 0, 1024, _height);
//    scrollView.frame =CGRectMake(0, 0, 1024, 768);
//    scrollView.contentSize = CGRectMake(0, 0, 1024, _height).size;
//    
//    if (([self interfaceOrientation] == UIDeviceOrientationLandscapeLeft) || 
//		([self interfaceOrientation] == UIDeviceOrientationLandscapeRight)) 
//	{
////        [scrollView performSelectorOnMainThread:@selector(invoke)];
//        menuView.frame = CGRectMake(0, 0, 1024, _height);
//		scrollView.frame =CGRectMake(0, 0, 1024, 768);
//        scrollView.contentSize = CGRectMake(0, 0, 1024, _height*1.01).size;
//        
//	} else {
//        menuView.frame = CGRectMake(0, 0, 1048, _height);
//        scrollView.frame =CGRectMake(-140, 0, 1024, 1024);
//        scrollView.contentSize = CGRectMake(0, 0, 768, _height*1.008).size;
//	}
//    
////    [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y + 5)  animated: YES];
//    
//}


//    
//    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"menuvideo.m4v" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:urlStr];
//    ////        
//    videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
//    videoPlayer.view.frame = CGRectMake(410, 5475,220, 150  );  
//    
//
//    //        //    videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
//    
//    videoPlayer.repeatMode = MPMovieRepeatModeOne;
//    //        [videoPlayer setFullscreen:YES];
////    [[videoPlayer ] setVolume:0.0];
//    [videoPlayer play];
//    
//    
//    ///
//    UIButton * rrbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    
//    // just about show where the button is
//    // only visible to the trained eye
//    [rrbtn setAlpha:0.02];
//    
//    // position match for the buttons over the pics in the 
//    // preview image
//    CGRect frame = CGRectMake(410, 5475 , 220.0 , 150.0 );
//    rrbtn.frame = frame;
//    rrbtn.tag = 97;
//    
//    // add the action to push the reader
//    // later it will be found out whichever pdf should be loaded
//    [rrbtn addTarget:self action:@selector(loadAndMove:) forControlEvents:UIControlEventTouchUpInside];


///

//if (tag == 3) {
//    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"circus-pro.m4v" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:urlStr];
//    ////        
//    videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
//    //            videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
//    
//    [self.view addSubview:videoPlayer.view];
//    //    videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
//    //    videoPlayer.repeatMode = MPMovieRepeatModeOne;
//    [videoPlayer setFullscreen:YES];
//    [videoPlayer play];
//}
//
//if (tag == 6) {
//    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"london.m4v" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:urlStr];
//    ////        
//    videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
//    //            videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
//    
//    [self.view addSubview:videoPlayer.view];
//    //    videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
//    //    videoPlayer.repeatMode = MPMovieRepeatModeOne;
//    [videoPlayer setFullscreen:YES];
//    [videoPlayer play];
//}

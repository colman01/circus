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

float imageWidth;
float imageHeight;
int count=0;

int entries[28];

CGFloat _height;
CGRect menuVidLand;
CGRect menuVidPort;

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
        menuVidLand = CGRectMake(410, 5475,220, 150); 
        menuVidPort  = CGRectMake(273, 5475,220, 150);
        mmRead = [[mmReader alloc] init];
        play   = [[Player alloc] init];
        [self fillArray];

        [self setupMenuBackground];
    }
    return self;
}


- (void) viewDidLoad {
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin = CGPointZero;
    
    //////////////////////////////////////////////////
    //// preparing UIScrollView
    //// with documentI as an image
    //////////////////////////////////////////////////

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float screenHeight = screenBounds.size.height;
    float screenWidth = screenBounds.size.width;
    
    int space, spacev;
    // vertical space
	spacev = 35;
    int f = 1;
    //        

    for (int i=0; i<100; i++) {
        
        f++;
        f = i % 3;
        
        // move along x
        space = 245*f;
        
        // reset after every level
        if (i == 0 || f == 3) {
            space = 0;
        }
        
        buttons[i] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttons[i] setAlpha:0.02];
        CGRect frame = CGRectMake(space + 165, spacev , 220.0 , 150.0 );
        buttons[i].frame = frame;
        buttons[i].tag = i;
        
        [buttons[i] addTarget:self action:@selector(loadAndMove:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:buttons[i]];
        
        // always increasing
        if (f == 2) {
            spacev	= spacev + 170;
        }
    }


    [self.view addSubview:scrollView];
//        [scrollView addSubview:rrbtn];
    
    if (!alreadyDone) {
        scrollView.hidden = YES;
        
        UIButton * continueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // just about show where the button is
        // only visible to the trained eye
        [continueButton setAlpha:0.7];
        
        // position match for the buttons over the pics in the 
        // preview image
        CGRect frame = CGRectMake(650, 865 , 85 , 35 );
        continueButton.frame = frame;
        UILabel * label = [[UILabel alloc] init];
        label.text = @"Continue";
        continueButton.accessibilityLabel = @"Continue";
        [continueButton setTitle:label.text forState:0];
        [continueButton addTarget:self action:@selector(hideWelcomeScreen:) forControlEvents:UIControlEventTouchUpInside];
        
        
        BOOL savedValue_ = [[NSUserDefaults standardUserDefaults] stringForKey:@"didLoad"];
        if (savedValue_ == YES) {
            alreadyDone = savedValue_;
            [[NSUserDefaults standardUserDefaults]
             setBool:YES forKey:@"didLoad"];
        }
        if(!alreadyDone) {
            
            [[NSUserDefaults standardUserDefaults]
             setBool:YES forKey:@"didLoad"];
            
            container = [[UIView alloc] initWithFrame:self.view.frame];
            welcomeScreen = [[UIImageView alloc] initWithFrame:self.view.frame];
            
            if(!alreadyDone) {
                
                PrepImage *pi = [[PrepImage alloc] init];
                welcome = [pi prepareImage:@"welcome1C.pdf"];
                welcomeScreen = [[UIImageView alloc] initWithImage:welcome];                
                welcomeScreen.frame = CGRectMake(0, -10 , 768 , 1024.0 );

                welcomeScreen.backgroundColor = [UIColor redColor];
               [pi release];
                
                welcomeScreen.image = welcome;

                [container addSubview:welcomeScreen];
                [container  addSubview:continueButton];
                [self.view addSubview:container];
            }
            alreadyDone = true;
            turn = false;
        }
    }
}


-(void) viewDidAppear:(BOOL)animated {
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"menuvideo.m4v" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    ////        
    videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    rrbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [rrbtn setBackgroundColor:[UIColor clearColor]];
    [videoPlayer.view setBackgroundColor:[UIColor clearColor]];
    //    videoPlayer.contentMode = UIViewContentModeCenter;
    
    if (([self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown ) || ([self interfaceOrientation] == UIInterfaceOrientationPortrait)) {
        videoPlayer.view.frame = menuVidPort;
        rrbtn.frame = menuVidPort;
        [self arrangeButtonsPort];
    } 
    else 
    {
        rrbtn.frame = menuVidLand;
        videoPlayer.view.frame   = menuVidLand;
        [self arrangeButtonsLand];
    }
    
    videoPlayer.repeatMode = MPMovieRepeatModeOne;

    // should be playing on the main menu
    [videoPlayer play];
    
    // just about show where the button is
    [rrbtn setAlpha:0.02];
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
    [mmRead release];
    mmRead = [[mmReader alloc] init];
}

-(void) viewWillDisappear:(BOOL)animated {
    //     [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];

}


#pragma mark - Rotation 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (!turn) {
        if ((interfaceOrientation ==  UIInterfaceOrientationPortrait ) || ( interfaceOrientation ==   UIInterfaceOrientationPortraitUpsideDown)) {
            [self arrangeButtonsPort];
            return YES;
        }     
        if ((interfaceOrientation ==  UIInterfaceOrientationLandscapeLeft ) || ( interfaceOrientation ==   UIInterfaceOrientationLandscapeRight)) {
            [self arrangeButtonsLand];
            return NO;
        }
    }
    return YES;
}

// sets preview.pdf as the background image object of the root controller

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    if ((interfaceOrientation ==  UIInterfaceOrientationPortraitUpsideDown ) || ( interfaceOrientation == UIInterfaceOrientationPortrait)) {
            videoPlayer.view.frame   = menuVidLand;
            rrbtn.frame = menuVidLand;
            [self arrangeButtonsLand];
    } 
    else 
    {
        videoPlayer.view.frame = menuVidPort;
        rrbtn.frame = menuVidPort;
        [self arrangeButtonsPort];
    }
    
}

-(void)willRotateToInterfaceOrientation: (UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    if ((orientation ==  UIInterfaceOrientationLandscapeLeft ) || ( orientation == UIInterfaceOrientationLandscapeRight)) {
        videoPlayer.view.frame   = menuVidPort;
        rrbtn.frame = menuVidPort;
        [self arrangeButtonsPort];
    } 
    else 
    {
        videoPlayer.view.frame = menuVidLand;
        rrbtn.frame = menuVidLand;
        [self arrangeButtonsLand];
    }
}

#pragma mark - Setup image in background

-(void) setupMenuBackground {
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float screenHeight = screenBounds.size.height;
    float screenWidth = screenBounds.size.width;
    
    scrollView = [[UIScrollView alloc] initWithFrame:screenBounds];
    PrepImage *pi = [[PrepImage alloc] init];
    menu = [pi prepareImage:@"preview.pdf"];
    _height = menu.size.height;
    imageWidth = menu.size.width;
    imageHeight = menu.size.height;
    menuView = [[UIImageView alloc] initWithImage:menu];
//    menuView.backgroundColor = [UIColor grayColor];
    CGRect frame = menuView.frame;
    frame.size.width = screenBounds.size.width;
    menuView.frame = frame;
    buttonContainer = [[UIView alloc] initWithFrame:menuView.frame];
    menuView.contentMode = UIViewContentModeCenter;
    [menuView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, menuView.frame.size.height*1.05)];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [scrollView addSubview:menuView];
    [pi release];
}

-(void) rotateWithState:(BOOL)horiz:(BOOL)vert {
    [mmRead rotateImage];
}


#pragma mark - pdf to be loaded

// bind to the correct buttons and push the next VC with the documentI
- (IBAction) loadAndMove:(id) sender {
    UIButton *button = sender;
    int tag = button.tag;
    //// 6,3,12,16,20,24,28,40,44,45,53,54,59,61,66,68,70,76,78,82,86,91,96,98,80,88
    if ( ( tag ==  6) ||( tag ==  3) ||( tag ==  12) || ( tag ==  16) || ( tag ==  20) || ( tag ==  24)  || ( tag ==  28) || ( tag ==  40) || ( tag ==  44) || ( tag ==  45) || ( tag ==  53) || ( tag ==  54) || ( tag ==  59) || ( tag ==  61) || ( tag ==  66) || ( tag == 68) || ( tag ==  70) || ( tag ==  76) || ( tag ==  78) || ( tag ==  82) || ( tag ==  86) || ( tag ==  91) || ( tag ==  96) || ( tag == 98) || ( tag == 1) || ( tag == 5) || ( tag == 8) || ( tag == 22) || ( tag == 36) || ( tag == 51) || ( tag == 64) || ( tag == 80) || ( tag == 88) )
    {
//        NSLog(@"does it work? %d ", button.tag);
    }
    else 
    {
        [mmRead setDocument:button.tag];
        [self.navigationController pushViewController:mmRead animated:YES];
    }
}




// array for shake filled with pdf index's 
// 6,3,12,16,20,24,28,40,44,45,53,54,59,61,66,68,70,76,78,82,86,91,96,98,80,88        

-(void) fillArray
{
    entries[0] = 0;
    entries[1] = 2;
    entries[2] = 3;
    entries[3] = 6;
    entries[4] = 12;
    entries[5] = 16;
    entries[6] = 20;
    entries[7] = 24;
    entries[8] = 28;
    entries[9] = 40;
    entries[10] = 44;
    entries[11] = 45;
    entries[12] = 53;
    entries[13] = 54;
    entries[14] = 59;
    entries[15] = 61;
    entries[16] = 66;
    entries[17] = 68;
    entries[18] = 70;
    entries[19] = 76;
    entries[20] = 78;
    entries[21] = 82;
    entries[22] = 86;
    entries[23] = 91;
    entries[24] = 96;
    entries[25] = 98;
    entries[26] = 80;
    entries[26] = 88;
}

#pragma mark - Methods for shake and welcome screen
- (IBAction) hideWelcomeScreen:(id) sender {
    scrollView.hidden = NO;
    container.hidden = YES;
    welcomeScreen.backgroundColor = [UIColor blueColor];
    turn = true;
}


//-(void) calcVolatility:(float *)values {
//    float frac = 0.1;
//    float res1;
//    float res3;
//    
//    for (int j=0; j<10; j++) {
//        float temp = (float)values[j];
//        res1 = res1 + (j - temp)*(j - temp);
//        if (values[j] < 0) {
//            values[j] = -1*values[j];
//        }
//        res3 += values[j];
//    }
//    float res2 = res1 * frac;
//    
//    if (res2 > 40 ) {
//        int n = (random() % 25);
//        mmRead = [[mmReader alloc] init]; // maybe it was already destroyed
//        [mmRead setDocument:n];
//        UIViewController * vc1 = [[UIViewController alloc] init];
//        vc1.view.backgroundColor = [UIColor redColor];
//        vc1.view.frame = CGRectMake(0, 0, 500, 500);
////        MyTableViewController *myTableView = [[MyTableViewController alloc] initWithNibName:@"MyTableView" bundle:[NSBundle mainBundle]];
////        [self.navigationController pushViewController:myTableView animated:YES];
////        [myTableView release]
//        
//        [self.navigationController pushViewController:vc1 ];
//        [mmRead release];
//    }    
//}


//// shake calculation, triggered under the correct volitility
//-(void) calcSum:(float *) values {
//    float result_1=0;
//    float result_2=0.0;
//    for (int j=0; j<10; j++) {
//
//        if (values[j] < 0) {
//            values[j] = -1*values[j];
//        }
//        
//        result_2 += values[j];
//        float temp = values[j];
//        
//        if (temp > 1.4) {
//            result_1 += temp;
//            
//        }
//        if (result_2 > 15) {
//            int n = (random() % 25);
//            n = abs(n);
//            n = entries[n];
//            n = 0;
//            [self.navigationController pushViewController:mmRead];
//        }
//    }
//}

int readings;
float values[];

NSMutableArray * myArray;
// UIAccelerometerDelegate method, called when the device accelerates.
//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
//    // Update the accelerometer graph view
//
//    if (readings == 10) {
//        readings = 0;
////        [self calcVolatility:values];
//        [self calcSum:values];
//    }
//    if (readings < 10) {
//        values[readings] = acceleration.y;
//        readings++;
//    }
//
//    NSLog(@"X: %f  +   Y: %f   +  Z:  %f",acceleration.x,acceleration.y,acceleration.z);
//}

#pragma mark - rotate buttons
-(void) arrangeButtonsPort {
    
    int space, spacev;
    // vertical space
	spacev = 35;
    int k = 0; // track the buttons with the tags for the listerner
    int f = 1;
    //        
    for (int i=0; i<100; i++) {
        f++;
        f = i % 3;
        // move along x
        space = 245*f;
        // reset after every level
        if (i == 0 || f == 3) {
            space = 0;
        }
        
        CGRect frame = CGRectMake(space + 28, spacev , 220.0 , 150.0 );
        buttons[i].frame = frame;
        // always increasing
        if (f == 2) {
            spacev	= spacev + 170;
        }
    }
}

-(void) arrangeButtonsLand {
    int space, spacev;
    // vertical space
	spacev = 35;
    int f = 1;
    //        
    for (int i=0; i<100; i++) {
        f++;
        f = i % 3;
        // move along x
        space = 245*f;
        // reset after every level
        if (i == 0 || f == 3) {
            space = 0;
        }
        CGRect frame = CGRectMake(space + 165, spacev , 220.0 , 150.0 );
        buttons[i].frame = frame;
        if (f == 2) {
            spacev	= spacev + 170;
        }
    }
}

@end

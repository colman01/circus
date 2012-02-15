//  Created by colman on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "mmReader.h"
#import "PrepImage.h"

@implementation mmReader
@synthesize  swipeLeftRecognizer, segmentedControl;

extern NSMutableArray *realNames;
extern int positionIntArray[];

extern NSMutableArray *vidNames;

extern UINavigationController * navcon;

extern NSMutableArray *webPages;

bool alreadyDone = false;
int position = 0;

float scrollPostion;


CGRect landscapeVideoFrame; // CGRectMake(60, 9280,455, 250);
CGRect portraitVideoFrame;  // CGRectMake(45, 6690,340, 200);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        [self setupGesture];
        bar = [[Bar alloc] init];
        CGRect r = CGRectMake(0, 50, 1024, 50);
        bar.frame = r;
        [bar setBackgroundColor:[UIColor grayColor]];
        bar.hidden = YES;
    }
    return self;
}

- (void)dealloc
{
//    [videoPlayer release];

//    [swipeLeftRecognizer release];
//    [segmentedControl release];
//    [tempI release];
//    [bar release];
    

//    [scrollView_doc release];
    
    [videoPlayer release];
    [docView release];
    [temp release]; 
    // will cause a crash
//    [scrollView_doc release];
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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [super viewDidLoad];
//    UIView* container = [[UIView alloc] init];
    UIBarButtonItem *rulerButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Ruler"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(toggleHideBar)];
    
    self.navigationItem.rightBarButtonItem = rulerButton;
    [rulerButton release];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewWillDisappear:(BOOL)animated {
//    [videoPlayer stop];


}

-(void) viewWillAppear:(BOOL)animated {
    [navcon setNavigationBarHidden:NO];
    // while this is happening another view
    // should be on the display until this code is finished
    [self addObjectView:pdfIndex];
    
    // add video button
    [self setupVideo];
        
    
     // Only a few lines here , in case of webview usage
//    NSString *urlAddress = @"http://www.naag.com";
    NSString *urlAddress = [webPages objectAtIndex:pdfIndex];

     
     NSURL *url = [NSURL URLWithString:urlAddress];
     NSURLRequest * requestObject = [NSURLRequest requestWithURL:url];
     blog = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 700)];
;
    [blog setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
     [blog loadRequest:requestObject];
//     [addressBar setText:urlAddress];
    blog.hidden = YES;
     [self.view addSubview:blog];
     
    [self.view addSubview:bar];
}


-(void)viewDidAppear:(BOOL)animated {
    [self setVideoFrame];
    [videoPlayer pause];
    int x = positionIntArray[pdfIndex];
    scrollPosition = (float)x;
//    [scrollView setContentOffset:CGPointMake(0, scrollPosition)  animated: NO];
//    scrollView.contentOffset = CGPointMake(0, scrollPosition);
    [scrollView_doc setContentOffset:CGPointMake(0, scrollPosition)  animated: YES];
}


#pragma mark - Document index tracking

// Get the name from the delegate global var realNames 
-(void) setDocument:(int ) docIndex {
    pdfIndex = docIndex;
}


// calculate the next index number for the pdf's
// when the swipe gesture is activated
-(void) getNextIndex{
    pdfIndex++;
    
    if (pdfIndex == 97) {
        pdfIndex = 0;
    }
    
    NSString * name = [realNames objectAtIndex:pdfIndex];
    BOOL move = true;
    NSString * nothing = @"";
    while (move) {
        if (![name isEqualToString:nothing]) {
            // pdf name found
            nameOfFile = name;
//            move = FALSE;
            break;
        }
        else {
            // keep going for the next pdf
            pdfIndex++;
            
            if (pdfIndex > 97) {
                pdfIndex = 0;
            }
            // get the next name in line untill reaching a pdf 
            name = [realNames objectAtIndex:pdfIndex];
        }
    }
}

-(void) getPreviousIndex{
    if (pdfIndex == 2) {
        pdfIndex = 0;
        nameOfFile = [realNames objectAtIndex:pdfIndex];
        return;
    }
    
    pdfIndex--;
    
    if (pdfIndex == -1) {
        pdfIndex = 97;
    }
    
    NSString * name = [realNames objectAtIndex:pdfIndex];
    BOOL keepmoving = true;
    NSString * nothing = @"";
    while (keepmoving) {
        
        
        if ([name isEqualToString:nothing]) {
            pdfIndex--;
            if (pdfIndex == 0) {
                pdfIndex = 97;
            }
            name = [realNames objectAtIndex:pdfIndex];
        }
        else {
            nameOfFile = name;
            keepmoving = FALSE;
        }
    }
}

-(void) setScrollPosition:(float)var {
	scrollPosition = var;
}

#pragma mark Video frame
-(void) setVideoFrame
{
    landscapeVideoFrame_97 = CGRectMake(60, 9280,455, 250);
    portraitVideoFrame_97  = CGRectMake(45, 6690,340, 200);
    
    landscapeVideoFrame_2  = CGRectMake(335, 970,435, 290);
    portraitVideoFrame_2   = CGRectMake(220, 715,340, 200);
    
    landscapeVideoFrame_0  = CGRectMake(351, 500,335, 190);
    portraitVideoFrame_0   = CGRectMake(245, 350,300, 180);
    
    if (pdfIndex == 97) {
        landscapeVideoFrame = landscapeVideoFrame_97;
        portraitVideoFrame  = portraitVideoFrame_97;
    }
    
    if (pdfIndex == 2) {
        landscapeVideoFrame = landscapeVideoFrame_2;
        portraitVideoFrame  = portraitVideoFrame_2;
    }
    
    if (pdfIndex == 0) {
        landscapeVideoFrame = landscapeVideoFrame_0;
        portraitVideoFrame  = portraitVideoFrame_0;
    }
    if (pdfIndex == 97 || pdfIndex == 2 || pdfIndex == 0) {
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            videoPlayer.view.frame = portraitVideoFrame;
        }
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            videoPlayer.view.frame = landscapeVideoFrame;
        }
    }
}

-(void) setupVideo {
    if (pdfIndex == 97) {
        NSString * fname = [vidNames objectAtIndex:0]; 
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:fname ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        ////        
        if (videoPlayer == nil) {

        }
        
        videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            videoPlayer.view.frame = portraitVideoFrame;
        }
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            videoPlayer.view.frame = landscapeVideoFrame;
        }

        // show video
//        videoPlayer.contentURL = url;
        videoPlayer.view.hidden = NO;
        [scrollView_doc addSubview:videoPlayer.view];
        [videoPlayer pause];
    }
    
    if (pdfIndex == 2) {
        NSString * fname = [vidNames objectAtIndex:1]; 
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:fname ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        ////        
        videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        [scrollView_doc addSubview:videoPlayer.view];
        [videoPlayer pause];
        
    }
    
    if (pdfIndex == 0) {
        NSString * fname = [vidNames objectAtIndex:2]; 
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:fname ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        //        ////        
        videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            videoPlayer.view.frame = portraitVideoFrame;
        }
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            videoPlayer.view.frame = landscapeVideoFrame;
        }
        
        [scrollView_doc addSubview:videoPlayer.view];
        [videoPlayer pause];
    }
}

#pragma mark - UIAccelerate Delegate Shake it!


int readings;
float values[];

// UIAccelerometerDelegate method, called when the device accelerates.
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    // Update the accelerometer graph view

    if (readings == 10) {
        readings = 0;
        [self calcSum:values];
    }
    if (readings < 10) {
        values[readings] = acceleration.y;
        readings++;
    }
//    NSLog(@"X: %f  +   Y: %f   +  Z:  %f",acceleration.x,acceleration.y,acceleration.z);
}

// shake calculation, triggered under the correct volitility
-(void) calcSum:(float *) values {
    float result_1=0;
    float result_2=0.0;
    for (int j=0; j<10; j++) {
        
        if (values[j] < 0) {
            values[j] = -1*values[j];
        }
        
        result_2 += values[j];
        float temp = values[j];
        
        if (temp > 1.4) {
            result_1 += temp;
            
        }
        if (result_2 > 12) {
            if (blog.hidden && ![[webPages objectAtIndex:pdfIndex] isEqualToString:@""]) {
                blog.hidden = NO;
            }
            else {
                blog.hidden = YES;
            }
        }
    }
}



#pragma mark - Rotations + Image control

//- (void)scrollViewDidScroll:(UIScrollView *)scrollViewDoc{
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    positionIntArray[pdfIndex] = (int)scrollView.contentOffset.y;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) | (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)) {

        switch (pdfIndex) {
            case 97:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = portraitVideoFrame_97;
                }
                break;
            case 2:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = portraitVideoFrame_2;
                }
                break;
            case 0:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = portraitVideoFrame_0;
                }
                break;
                
            default:
                break;
        }
        
        // location where you were and move there
        scrollPosition = scrollPosition*.78;
        [scrollView_doc setContentOffset:CGPointMake(0, scrollPosition)  animated: YES];
    }
    
    if ((interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) | (interfaceOrientation == UIInterfaceOrientationPortrait)) {
        switch (pdfIndex) {
            case 97:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = landscapeVideoFrame_97;
                }
                break;
            case 2:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = landscapeVideoFrame_2;
                }

                break;
            case 0:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = landscapeVideoFrame_0;
                }
                break;
                
            default:
                break;
        }
        
        // locate where you were and move there
        scrollPosition = scrollPosition*1.3;
        [scrollView_doc setContentOffset:CGPointMake(0, scrollPosition)  animated: YES];
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //    [self rotateImage];
    float w1 = [[UIScreen mainScreen] bounds].size.width;
    float h1 = [[UIScreen mainScreen] bounds].size.height;
    float w;
    float h;
    
    if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
		(interfaceOrientation == UIInterfaceOrientationLandscapeRight)) 
	{
        w = h1;
        h = w1;
        docView.frame = CGRectMake(0, 0, w, height);
		scrollView_doc.frame =CGRectMake(0, 0,  w, h);
        scrollView_doc.contentSize = CGRectMake(0, 0, 1024, height*1.03).size;
	} else {
        w = w1;
        h = h1;
        docView.frame = CGRectMake(0, 0, w, height*.72);
        scrollView_doc.frame =CGRectMake(0, 0, w, h);
        scrollView_doc.contentSize = CGRectMake(0, 0, w, height*.755).size;
	}
    
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        CGPoint pt = [bar frame].origin;
        if (pt.y > 740 ) {
            CGRect r = CGRectMake(0, 650, 1024, 50);
            bar.frame =  r;
        }
    }
	return YES;
}


-(void)willRotateToInterfaceOrientation: (UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    scrollPosition = scrollView_doc.contentOffset.y;
}

#pragma mark - Setup 

-(void) toggleHideBar {
    if (bar.hidden) {
        bar.hidden = NO;
    }
    else {
        bar.hidden = YES;
    }
}


-(void) setupMenuBackground:(NSString *) fname {
    PrepImage *pi = [[PrepImage alloc] init];
    docI = [pi prepareImage:fname];
    docView = [[UIImageView alloc] initWithImage:docI];
    height = docI.size.height;
    temp = [[UIImageView alloc] init];
    [pi release];
}


-(void) addObjectView: (int *) which{
    [self setupMenuBackground:[realNames objectAtIndex:which]];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin = CGPointZero;
    
    //////////////////////////////////////////////////
    // preparing UIScrollView
    // with documentI as an image
    //////////////////////////////////////////////////
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float screenHeight = screenBounds.size.height;
    float screenWidth = screenBounds.size.width;
    
    
    if (([self interfaceOrientation] == UIDeviceOrientationLandscapeLeft) || 
        ([self interfaceOrientation] == UIDeviceOrientationLandscapeRight)) 
    {
        scrollView_doc = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)] autorelease] ;
        scrollView_doc.contentSize = CGRectMake(0, 0, screenWidth, height*0.75).size;   
        
    } else {
        scrollView_doc = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenHeight, screenWidth)] autorelease] ;
        scrollView_doc.contentSize = CGRectMake(0, 0, screenWidth, height*1.02).size;   
    }
    scrollView_doc.delegate = self;
    [scrollView_doc addSubview:docView];
    [self.view addSubview:scrollView_doc];
    [self.view addSubview:bar];
}

#pragma mark - Gesture

-(void) setupGesture {
	UIGestureRecognizer * recognizer;
	// default right recogniser
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipeOne:)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
	
	// left recognizer
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwapTwo:)];
	self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
	if ([segmentedControl selectedSegmentIndex] == 0) {
        [self.view addGestureRecognizer:swipeLeftRecognizer];
    }
    self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;
	[recognizer release];
}

- (void)doSwipeOne:(UISwipeGestureRecognizer *)recognizer {
    [self performTransition:true];
//    [videoPlayer pause];
}


- (void)doSwapTwo:(UISwipeGestureRecognizer *) recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
  		[self performTransition:false];
//        [videoPlayer pause];
    }
}

/*
 * transitionType = true = next pdf
 * transitionType = false = go back
 */

-(void)performTransition:(BOOL *)transitionType
{
    
    // First create a CATransition object to describe the transition
//	CATransition *transition = [CATransition animation];
//	// Animate over 3/4 of a second
//	transition.duration = 0.75;
//	// using the ease in/out timing function
//	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//	
//	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
//	NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
//	NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
//    //	int rnd = random() % 4;
//	int rnd = 3;
//	transition.type = types[rnd];
//    
//	transition.type = kCATransitionReveal;
    
	if (transitionType == true) {
//        transition.subtype = kCATransitionFromLeft;
        // need to get the next pdf name index and convert to image
        // by calling getNextIndex, the pdfIndex is ready
        [self getPreviousIndex];
	}
	else {
//        transition.subtype = kCATransitionFromRight;
        // need to get the next pdf name index and convert to image
        // by calling getNextIndex, the pdfIndex is ready
        [self getNextIndex];
	}
    
//    transitioning = YES;
//	transition.delegate = self;
    
    NSString *urlAddress = [webPages objectAtIndex:pdfIndex];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest * requestObject = [NSURLRequest requestWithURL:url];
    
    [blog loadRequest:requestObject];
    
    [temp setImage:nil];
    PrepImage *pi = [[PrepImage alloc] init];
    // nameOfFile is ready
    temp.image = [pi prepareImage:nameOfFile] ; 
    
    
    height = [pi geth];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float screenHeight = screenBounds.size.height;
    float screenWidth = screenBounds.size.width;
    
    
    // set image and scrollView frame
    if (([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || 
        ([self interfaceOrientation] == UIInterfaceOrientationLandscapeRight)) 
    {
        temp.frame = CGRectMake(0, 0, screenHeight, height);
        [scrollView_doc addSubview:temp];
        scrollView_doc.contentSize = CGRectMake(0, 0, screenHeight, height).size;
        
    } else {
        temp.frame = CGRectMake(0, 0, screenWidth, height*.75);
        [scrollView_doc addSubview:temp];
        scrollView_doc.contentSize = CGRectMake(0, 0, screenWidth, height*.75).size;
    }
    
    [pi release];
//    [self.view.layer addAnimation:transition forKey:nil];
    docView.hidden = YES;
    temp.hidden = NO;
    
    [docView setImage:nil];
    
    // leave docView as the main UIImageView on screen after the transition
    UIImageView * tmp = temp;
    temp = docView;
    docView = tmp;
    
    int x = positionIntArray[pdfIndex];
    scrollPosition = (float ) x;
    [scrollView_doc setContentOffset:CGPointMake(0, scrollPosition)  animated: YES];
//     [scrollView setContentOffset:CGPointMake(0, 1024)  animated: YES];
    

    // after transition is called the
    // frame is off on the next image  // this call is not liked
    /////
    
    if ((self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) | (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)) {
        
        switch (pdfIndex) {
            case 97:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = portraitVideoFrame_97;
                }
                break;
            case 2:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = portraitVideoFrame_2;
                }
                break;
            case 0:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = portraitVideoFrame_0;
                }
                break;
                
            default:
                break;
        }
        //        videoPlayer.view.frame = portraitVideoFrame_97;
        
        // location where you were and move there
        scrollPosition = scrollPosition*.78;
        [scrollView_doc setContentOffset:CGPointMake(0, scrollPosition)  animated: YES];
    }
    
    if ((self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) | (self.interfaceOrientation == UIInterfaceOrientationPortrait)) {
        
        //        videoPlayer.view.frame = landscapeVideoFrame_97;
        switch (pdfIndex) {
            case 97:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = landscapeVideoFrame_97;
                }
                break;
            case 2:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = landscapeVideoFrame_2;
                }
                
                break;
            case 0:
                if (videoPlayer != nil) {
                    videoPlayer.view.frame = landscapeVideoFrame_0;
                }
                break;
                
            default:
                break;
        }
        
        // locate where you were and move there
        scrollPosition = scrollPosition*1.3;
        [scrollView_doc setContentOffset:CGPointMake(0, scrollPosition)  animated: YES];
    }
    /////
    
    if (videoPlayer != nil) {
        videoPlayer.view.hidden = YES;
//        [videoPlayer.view removeFromSuperview];
//        [videoPlayer release];
    }

    if (pdfIndex == 97 || pdfIndex == 2 || pdfIndex == 0) {
        [self setupVideo];
        [self setVideoFrame];
    }
//    [videoPlayer pause];

    
}

#pragma mark - Touches Ready for use, if needed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

@end

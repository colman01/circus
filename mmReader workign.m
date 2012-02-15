//  Created by colman on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "mmReader.h"
#import "PrepImage.h"

@implementation mmReader
@synthesize  swipeLeftRecognizer, segmentedControl;

extern bool horiz;
extern bool vert;

extern bool localHorizVariable;
extern bool localVertVariable;

extern NSMutableArray *realNames;
extern int positionIntArray[];

extern NSMutableArray *vidNames;

extern UINavigationController * navcon;

bool alreadyDone = false;
int position = 0;

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
    [super viewDidLoad];
//    UIView* container = [[UIView alloc] init];
    UIBarButtonItem *rulerButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Ruler"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(off)];
//    [container addSubview:rulerButton];
    
    
    self.navigationItem.rightBarButtonItem = rulerButton;
    
    [rulerButton release];

}

-(void) off {
    if (bar.hidden) {
        bar.hidden = NO;
    }
    else {
        bar.hidden = YES;
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewWillDisappear:(BOOL)animated {
    [videoPlayer stop];
    [videoPlayer release];
    [docView release];
    [temp release]; 

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    [self rotateImage];
//    float w = UIScreen mainScreen] frame].size.width;
//    float h = [[UIScreen mainScreen] frame].size.height;
    float w;
    float h;
    
    if ((interfaceOrientation == UIDeviceOrientationLandscapeLeft) || 
		(interfaceOrientation == UIDeviceOrientationLandscapeRight)) 
	{
        w = 1024;
        h = 768;
        docView.frame = CGRectMake(0, 0, w, height);
		scrollView.frame =CGRectMake(0, 0,  w, h);
        scrollView.contentSize = CGRectMake(0, 0, 1024, height*1.03).size;
        

        
	} else {
        w = 768;
        h = 1024;
        docView.frame = CGRectMake(0, 0, w, height*.72);
        scrollView.frame =CGRectMake(0, 0, w, h);
        scrollView.contentSize = CGRectMake(0, 0, w, height*.755).size;
	}


    
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || UIDeviceOrientationLandscapeRight) {
        CGPoint pt = [bar frame].origin;
        if (pt.y > 740 ) {
            CGRect r = CGRectMake(0, 650, 1024, 50);
            bar.frame =  r;

        }
    }
//    
//    if (pdfIndex == 97) {
//        if(([self interfaceOrientation] == UIDeviceOrientationLandscapeLeft) || 
//           ([self interfaceOrientation] == UIDeviceOrientationLandscapeRight) ) {
////            videoPlayer.view.frame = CGRectMake(60, 9280,455, 250  ); 
//            videoPlayer.view.frame = CGRectMake(0, 0,455, 250  ); 
//
//        }
//        if(([self interfaceOrientation] == UIDeviceOrientationPortrait) || 
//           ([self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) ) {
////            videoPlayer.view.frame = CGRectMake(45, 6690,340, 200  );   
//            videoPlayer.view.frame = CGRectMake(0, 500,455, 250  ); 
//        }
//    }
    
    NSLog(@"%f", scrollView.contentSize.height);
    
	return YES;
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
        scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)] autorelease] ;
        scrollView.contentSize = CGRectMake(0, 0, screenWidth, height*0.75).size;   
        
    } else {
        scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenHeight, screenWidth)] autorelease] ;
        scrollView.contentSize = CGRectMake(0, 0, screenWidth, height*1.02).size;   
    }
    
    
    
    float w = 768.0;
    
//    scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, 1024)] autorelease] ;
    
    // not the image only the content area
    //    scrollView.contentSize = CGRectMake(0, 0, 768, menu.size.height + 1000).size;
    
 
    [scrollView addSubview:docView];
    [scrollView addSubview:temp];

    [self.view addSubview:scrollView];
    
   [self.view addSubview:bar];
}

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

// calculate the next index number for the pdf's
// when the swipe gesture is activated
-(void) getNextIndex{
//    NSLog(@"am I called too much?");
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
            NSLog(@"%@", name);
            move = FALSE;
            break;
        }
        else {
            // keep going for the next pdf
            pdfIndex++;
            
            if (pdfIndex > 97) {
                pdfIndex = 0;
            }
            NSLog(@"before crash point %d", pdfIndex);
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
            NSLog(@"%@", name);
            keepmoving = FALSE;
        }
    }
}

- (void)doSwipeOne:(UISwipeGestureRecognizer *)recognizer {
    [self performTransition:true];
}


- (void)doSwapTwo:(UISwipeGestureRecognizer *) recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"after inc %d", pdfIndex);
  		[self performTransition:false];
    }
}


-(void)performTransition:(BOOL *)transitionType
{

	if (transitionType == true) {

        // need to get the next pdf name index and convert to image
        // by calling getNextIndex, the pdfIndex is ready
        [self getPreviousIndex];
	}
	else {

        // need to get the next pdf name index and convert to image
        // by calling getNextIndex, the pdfIndex is ready
        [self getNextIndex];
	}
    

    
    [temp setImage:nil];
    PrepImage *pi = [[PrepImage alloc] init];
    // nameOfFile is ready
    temp.image = [pi prepareImage:nameOfFile] ; 
    

    height = [pi geth];

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float screenHeight = screenBounds.size.height;
    float screenWidth = screenBounds.size.width;
    
    
    if (([self interfaceOrientation] == UIDeviceOrientationLandscapeLeft) || 
        ([self interfaceOrientation] == UIDeviceOrientationLandscapeRight)) 
    {
        temp.frame = CGRectMake(0, 0, screenHeight, height);
        [scrollView addSubview:temp];
        scrollView.contentSize = CGRectMake(0, 0, screenHeight, height).size;
        //        temp.frame =  CGRectMake(0, 0, 1024, height);
        //        //    [scrollView addSubview:temp];
        //        scrollView.contentSize = CGRectMake(0, 0, 1024, height).size;
        
    } else {
        temp.frame = CGRectMake(0, 0, screenWidth, height*.75);
        [scrollView addSubview:temp];
        scrollView.contentSize = CGRectMake(0, 0, screenWidth, height*.75).size;
        //        temp.frame =  CGRectMake(0, 0, 768, height*.75);
        //        //    [scrollView addSubview:temp];
        //        scrollView.contentSize = CGRectMake(0, 0, 768, height*.75).size;    
    }
//    if (localHorizVariable) {
//        temp.frame =  CGRectMake(0, 0, 1024, height);
//        //    [scrollView addSubview:temp];
//        scrollView.contentSize = CGRectMake(0, 0, 1024, height).size;    
//    }
//    if (localVertVariable) {
//        temp.frame =  CGRectMake(0, 0, 768, height*.75);
//        //    [scrollView addSubview:temp];
//        scrollView.contentSize = CGRectMake(0, 0, 768, height*.75).size;    
//    }

    [pi release];
    
    docView.hidden = YES;
    temp.hidden = NO;
    
    [docView setImage:nil];
    
    // leave docView as the main UIImageView on screen after the transition
    UIImageView * tmp = temp;
    temp = docView;
    docView = tmp;
    
    int x = positionIntArray[pdfIndex];
    scrollPosition = (float)x;
    [scrollView setContentOffset:CGPointMake(0, scrollPosition)  animated: YES];
    
    // after transition is called the
    // frame is off on the next image
//    [self rotateImage];
//    [self shouldAutorotateToInterfaceOrientation];
}


-(void) setScrollPosition:(float)var {
	scrollPosition = var;
}

// Get the name from the delegate global var realNames 
-(void) setDocument:(int ) docIndex {
    pdfIndex = docIndex;
}


-(void) viewWillAppear:(BOOL)animated {
    [navcon setNavigationBarHidden:NO];
    // while this is happening another view
    // should be on the display until this code is finished
    [self addObjectView:pdfIndex];

    
    if (pdfIndex == 97) {
        NSString * fname = [vidNames objectAtIndex:0]; 
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:fname ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        ////        
        videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        if(([self interfaceOrientation] == UIDeviceOrientationLandscapeLeft) || 
           ([self interfaceOrientation] == UIDeviceOrientationLandscapeRight) ) {
//            videoPlayer.view.frame = CGRectMake(45, 6690,340, 200  );  
//            videoPlayer.view.frame = CGRectMake(0, 0,400, 200);  
            videoPlayer.view.frame = CGRectMake(60, 9280,455, 250  ); 
        }
        if(([self interfaceOrientation] == UIDeviceOrientationPortrait) || 
           ([self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) ) {
//            videoPlayer.view.frame = CGRectMake(60, 9280,455, 250  ); 
             videoPlayer.view.frame = CGRectMake(45, 6690,340, 200  );  
//            videoPlayer.view.frame = CGRectMake(0, 0,400, 200);  
        }
//        [videoPlayer.view setAutoresizingMask:UIViewContentModeScaleAspectFit];
        //        //    videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
        
//        videoPlayer.repeatMode = MPMovieRepeatModeOne;
        //        [videoPlayer setFullscreen:YES];
        //    [[videoPlayer ] setVolume:0.0];
        //        [videoPlayer play];
        
//        videoPlayer.view.hidden = YES;
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [button addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
//        
//        CGRect frame = CGRectMake(45, 6690 , 50, 50);
//        button.frame = frame;
        [scrollView addSubview:videoPlayer.view];
        
//        [scrollView addSubview:button];
    }
    
    if (pdfIndex == 2) {
        NSString * fname = [vidNames objectAtIndex:1]; 
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:fname ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        ////        
        videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        if(([self interfaceOrientation] == UIDeviceOrientationLandscapeLeft) || 
           ([self interfaceOrientation] == UIDeviceOrientationLandscapeRight) ) {
            videoPlayer.view.frame = CGRectMake(0, 0,400, 200);  
        }
        if(([self interfaceOrientation] == UIDeviceOrientationPortrait) || 
           ([self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) ) {
            videoPlayer.view.frame = CGRectMake(0, 0,400, 200);  
        }
        
        //        //    videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
        
        //        videoPlayer.repeatMode = MPMovieRepeatModeOne;
        //        [videoPlayer setFullscreen:YES];
        //    [[videoPlayer ] setVolume:0.0];
        //        [videoPlayer play];
//        videoPlayer.view.hidden = YES;
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [button addTarget:self action:@selector(loadAndMove:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [scrollView addSubview:button];
        [scrollView addSubview:videoPlayer.view];
        

    }
    
    if (pdfIndex == 0) {
        NSString * fname = [vidNames objectAtIndex:2]; 
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:fname ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        ////        
        videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        if(([self interfaceOrientation] == UIDeviceOrientationLandscapeLeft) || 
           ([self interfaceOrientation] == UIDeviceOrientationLandscapeRight) ) {
            videoPlayer.view.frame = CGRectMake(0, 0, 200, 200  );  
        }
        if(([self interfaceOrientation] == UIDeviceOrientationPortrait) || 
           ([self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) ) {
            videoPlayer.view.frame = CGRectMake(0, 0, 200, 250  );  
        }
        
        //        //    videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
        
        //        videoPlayer.repeatMode = MPMovieRepeatModeOne;
        //        [videoPlayer setFullscreen:YES];
        //    [[videoPlayer ] setVolume:0.0];
        //        [videoPlayer play];
        [scrollView addSubview:videoPlayer.view];
    }

    
//    
//    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"rr.m4v" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:urlStr];
//    ////        
//    videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
//    videoPlayer.view.frame = CGRectMake(0, 0,200, 200  );  
//    
//    
//    //        //    videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
//    
//    videoPlayer.repeatMode = MPMovieRepeatModeOne;
//    //        [videoPlayer setFullscreen:YES];
//    //    [[videoPlayer ] setVolume:0.0];
//    [videoPlayer play];
//    [self.view addSubview:videoPlayer.view];
//    [self rotateImage];
    
/////////////////////////////////////////////////////////////////    
    /*
    NSString *urlAddress = @"http://www.naag.com";
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest * requestObject = [NSURLRequest requestWithURL:url];
    
    blog = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 500, 800)];
    
    blog.backgroundColor   = [UIColor redColor];
    
    [blog loadRequest:requestObject];
    */
//    [addressBar setText:urlAddress];
//    docView.hidden = YES;
//    [self.view addSubview:blog];
        [self.view addSubview:bar];
/////////////////////////////////////////////////////////////////


}

-(void) playVideo {
    videoPlayer.view.hidden = NO;
    [videoPlayer play];
}

-(void)viewDidAppear:(BOOL)animated {
//    [self rotateImage];
    
//    if (pdfIndex == 97) {
//        if(([self interfaceOrientation] == UIDeviceOrientationLandscapeLeft) || 
//           ([self interfaceOrientation] == UIDeviceOrientationLandscapeRight) ) {
//            videoPlayer.view.frame = CGRectMake(45, 6690,340, 200  );  
//        }
//        if(([self interfaceOrientation] == UIDeviceOrientationPortrait) || 
//           ([self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) ) {
//            videoPlayer.view.frame = CGRectMake(60, 9280,455, 250  );  
//        }
//    }
//    [self shouldAutorotateToInterfaceOrientation:[self interfaceOrientation]];
    
    
//    [videoPlayer stop];
     [videoPlayer pause];
        
    int x = positionIntArray[pdfIndex];
    scrollPosition = (float)x;
    [scrollView setContentOffset:CGPointMake(0, scrollPosition)  animated: YES];
}


/////////////////////////////////////
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
}
////////////////////////////////////
-(void) rotateImage {

    if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || 
		([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) 
	{
        docView.frame = CGRectMake(0, 0, 1024, height);
		scrollView.frame =CGRectMake(0, 0,  1024, 768);
        scrollView.contentSize = CGRectMake(0, 0, 1024, height*1.03).size;
        
	} else {
        docView.frame = CGRectMake(0, 0, 768, height*.72);
        scrollView.frame =CGRectMake(0, 0, 768, 1024);
        scrollView.contentSize = CGRectMake(0, 0, 768, height*.755).size;
        scrollView.delegate = self;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollViewDoc{
    positionIntArray[pdfIndex] = (int)scrollViewDoc.contentOffset.y;
}

@end

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    // 	NSArray *allTouches = [touches allObjects]; 
//    //	int count = [allTouches count]; 
//    //    
//    //    NSLog(@"%d, count");
//    
//    //    touch1 = [[allTouches objectAtIndex:0] locationInView:self]; 
//    //    NSLog(@"%f, touch1.x");
//    
//    //    UITouch *touch = [[event allTouches] anyObject];
//    //    CGPoint touchLocation = [touch locationInView:touch.view];
//    //    
//    //    NSLog(@"%f", touchLocation.x);
//    //    NSLog(@"%f", touchLocation.y);
//    //    
//    //    UIView *touchedView = [[touches anyObject] view];
//    
//    //    if (bar == touchedView) {
//    //        NSLog(@"touches this view");
//    //        CGRect r = CGRectMake(0, touchLocation.y + 25, 768, 50);
//    //        bar.frame = r;
//    ////        bar.center = touchLocation;
//    //    }
//}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	UITouch *touch = [[event allTouches] anyObject];
//    CGPoint touchLocation = [touch locationInView:touch.view];
//    
//    NSLog(@"%f", touchLocation.x);
//    NSLog(@"%f", touchLocation.y);
//    
//    UIView *touchedView = [[touches anyObject] view];
//    
//    if (bar == touchedView) {
//        NSLog(@"touches this view");
//        CGRect r = CGRectMake(0, touchLocation.y + 25, 768, 50);
//        bar.frame = r;
//        //        bar.center = touchLocation;
//    }
//
//}

//-(void)performTransition:(BOOL *)transitionType
//{
//	// First create a CATransition object to describe the transition
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
//	if (transitionType == true) {
//		transition.subtype = kCATransitionFromLeft;
//        // need to get the next pdf name index and convert to image
//        // by calling getNextIndex, the pdfIndex is ready
//        [self getPreviousIndex];
//	}
//	else {
//		transition.subtype = kCATransitionFromRight;
//        // need to get the next pdf name index and convert to image
//        // by calling getNextIndex, the pdfIndex is ready
//        [self getNextIndex];
//	}
//    
//	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
//	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
//	transitioning = YES;
//	transition.delegate = self;
//    
//    [temp setImage:nil];
//    PrepImage *pi = [[PrepImage alloc] init];
//    // nameOfFile is ready
//    temp.image = [pi prepareImage:nameOfFile] ; 
//
//    height = [pi geth];
//    temp.frame =  CGRectMake(0, 0, 768, height*.75);
////    [scrollView addSubview:temp];
//    scrollView.contentSize = CGRectMake(0, 0, 768, height*.75).size;    
//    [pi release];
//    
//	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
//	[self.view.layer addAnimation:transition forKey:nil];
//    // transitioning is active
//    
//    docView.hidden = YES;
//    temp.hidden = NO;
//    
//    [docView setImage:nil];
//
//    // leave docView as the main UIImageView on screen after the transition
//    UIImageView * tmp = temp;
//    temp = docView;
//    docView = tmp;
//    
//    int x = positionIntArray[pdfIndex];
//    scrollPosition = (float)x;
//    [scrollView setContentOffset:CGPointMake(0, scrollPosition)  animated: YES];
//    
//    // after transition is called the
//    // frame is off on the next image
//    [self rotateImage];
//}


//
//  VidPlayer.m
//  CIRCUS
//
//  Created by colman on 22.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VidPlayer.h"


@implementation VidPlayer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"redridinghood.mp4" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [self addSubview:videoPlayer.view];
    //    videoPlayer.view.frame = CGRectMake(0, 0,768, 1000);  
    //    videoPlayer.repeatMode = MPMovieRepeatModeOne;
    [videoPlayer setFullscreen:YES];
    [videoPlayer play];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

//
//  Bar.m
//  CIRCUS
//
//  Created by colman on 14.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bar.h"


@implementation Bar



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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    start = [[touches anyObject] locationInView:self];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self.superview];
//    pt.x -= start.x;
    pt.x = 0;
    pt.y -= start.y;
    if (pt.y > 20) {
        CGRect frm = [self frame];
        frm.origin = pt;
        [self setFrame:frm];
    }
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
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        CGPoint pt = [self frame].origin;
        if (pt.y > 1024 ) {
            CGRect frm = CGRectMake(0, 0, 1024, 718);
            [self setFrame:frm];
            NSLog(@"here");
        }
    }
	return YES;
}

@end

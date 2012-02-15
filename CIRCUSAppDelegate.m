//
//  CIRCUSAppDelegate.m
//  CIRCUS
//
//  Created by colman on 27.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CIRCUSAppDelegate.h"

#import "CIRCUSViewController.h"

@implementation CIRCUSAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

// filenames
NSMutableArray * realNames;

NSMutableArray * webPages;

NSMutableArray * vidNames;


// store scrollView content offset
int positionIntArray[100];


UINavigationController * navcon;

NSLock *lock;


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{


    
    

////    NSString *valueToSave = @"someValue";
////    [[NSUserDefaults standardUserDefaults]
////     setObject:valueToSave forKey:@"preferenceName"];
//    
////    BOOL didLoad = YES;
////    [[NSUserDefaults standardUserDefaults]
////     setObject:didLoad forKey:@"didLoad"];
//    BOOL savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"didLoad"];    

    [[NSUserDefaults standardUserDefaults]
     setBool:YES forKey:@"didLoad"];
//    
    NSUserDefaults *loginPrefs = [NSUserDefaults standardUserDefaults];
    

//    [loginPrefs setBool:NO forKey:@"didLoad"];
    
     BOOL wasLoadedAlready = [loginPrefs stringForKey:@"didLoad"];
    
    if (wasLoadedAlready) {
        NSLog(@"was loaded Aready has been set to true");
    }
    
//    // Saving an NSString
//    [loginPrefs setObject:self.handyNumberTextField.text forKey:@"keyHandyNumber"];
//    
//    if (self.saveLoginSwitch.on) {
//        [loginPrefs setObject:self.passwordTextField.text forKey:@"keyPassword"];
//        [loginPrefs setBool:YES forKey:@"keySaveLogin"];
//    }
//    else {
//        [loginPrefs setObject:@"" forKey:@"keyPassword"];
//        [loginPrefs setBool:NO forKey:@"keySaveLogin"];
//    }

    
    
    // the global defined above realNames
    // it prepares with the filenames added in hard coded style
    [self prepareNames];
    [self prepareVidNames];
    [self prepareUrl];
    
    // puts a zero 0.0 value for use of remembering
    // where the scrollViewDoc content offset should be
    // if you have been viewing a particular pdf already
    [self preparePositons];
    
    // some kind of navigation controller is active
    navcon	= [[UINavigationController alloc] init];
    [navcon setNavigationBarHidden:YES];
    
    circus =  [[CIRCUSViewController alloc] init];
    
    //  [navcon pushViewController:rvc animated:YES];
    [navcon pushViewController:circus animated:YES];
    
    //    self.window.rootViewController = self.viewController;
    
    self.window.rootViewController = navcon;
    [self.window addSubview:navcon.view];
    
//    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - setup 

-(void) preparePositons {
    
    for (int i = 0; i<100; i++) {
        positionIntArray[i] = 0;
    }
}


-(void) prepareUrl {
    
    webPages =  [[NSMutableArray alloc] init];
    [webPages addObject:@""];  //0
    [webPages addObject:@""];  // the material 1
    [webPages addObject:@"http://www.naag.com"]; // 2 naag.com
    [webPages addObject:@""];  // bloggers gone wild 3
    [webPages addObject:@""];  // 4
    
    [webPages addObject:@""];  // index 5  Fashion a topic ...
    [webPages addObject:@""];  // bloggers gone wild LOWER 6
    [webPages addObject:@""];  // the artists 7
    [webPages addObject:@""];  // index 8 Fashion a topic.... 8
    [webPages addObject:@"http://http://www.playlust.net"]; // 9  playlust.net
    
    [webPages addObject:@"http://blicablica.blogspot.com"];  //10  blicablica.blogspot.com
    [webPages addObject:@""]; // lion pic UPPER  11
    [webPages addObject:@""]; // queen inside 12
    [webPages addObject:@""]; // 13
    [webPages addObject:@""]; // lion pic LOWER 14
    
    //    [webPages addObject:@"2_projectrunaway.pdf"];  //15
    [webPages addObject:@""];  //15
    [webPages addObject:@""]; //   16
    [webPages addObject:@"http://digital-diamonds.blogspot.com"]; // 17  digital-diamonds.blogspot.com
    [webPages addObject:@"http://digital-diamonds.blogspot.com"]; // 18  digital-diamonds.blogspot.com
    [webPages addObject:@"http://blicablica.blogspot.com"]; // 19 blicablica.blogspot.com
    
    [webPages addObject:@""];  //20  
    [webPages addObject:@"http://www.addictedtostrangers.com"]; // 21  addictedtostrangers.com
    [webPages addObject:@""]; // 22
    [webPages addObject:@"http://www.addictedtostrangers.com"]; // 23  addictedtostrangers.com
    [webPages addObject:@""]; // 24
    
    
    [webPages addObject:@"http://runwayrebels.blogspot.com"];  // 25  runwayrebels.blogspot.com
    [webPages addObject:@""];  // 26
    
    ////////// section 3 /////////////
    
    [webPages addObject:@""];  // 27
    [webPages addObject:@""];  // 28
    [webPages addObject:@"http://www.floriansiebeck.com"];  // 29  www.floriansiebeck.com
    
    [webPages addObject:@""];  // 30
    [webPages addObject:@"http://fashionpirates.blogspot.com"];  // 31  fashionpirates.blogspot.com
    [webPages addObject:@"http://www.theconsideredensemble.com"];  // 32  theconsideredensemble.com
    [webPages addObject:@""];  // 33
    [webPages addObject:@""];  // 34
    
    [webPages addObject:@""];  // 35
    [webPages addObject:@""];  // 36 thats the best of beauty
    [webPages addObject:@"http://carmenrueter.wordpress.com"];  // 37  carmenrueter.wordpress.com
    [webPages addObject:@""];  // 38
    [webPages addObject:@""];  // 39
    
    [webPages addObject:@""];  // 40
    [webPages addObject:@"http://www.fourfivex.net"];  // 41  www.fourfivex.net
    
    
    ///////////// section 4 /////////////////
    
    [webPages addObject:@""];  // 42
    [webPages addObject:@""];  // 43
    [webPages addObject:@""];  // 44
    
    [webPages addObject:@""];  // 45
    [webPages addObject:@"http://boticapop.blogspot.com"];  // 46  boticapop.blogspot.com
    [webPages addObject:@"http://beesandballons.blogspot.com"];  // 47  beesandballons.blogspot.com
    [webPages addObject:@"http://www.hiabstyle.co.uk"];  // 48  hiabstyle.co.uk
    [webPages addObject:@""];  // 49
    
    [webPages addObject:@""];  // 50
    [webPages addObject:@""];  // 51 true mystery of the world is the visible, not the invisible
    [webPages addObject:@""];  // 52
    [webPages addObject:@""];  // 53
    [webPages addObject:@""];  // 54
    
    [webPages addObject:@"http://www.athenswears.com"];  // 55  athenswears.com
    [webPages addObject:@"http://www.realnob.blogspot.com"];  // 56  realnob.blogspot.com
    
    
    ////////////// section 4 ////////////
    [webPages addObject:@""];  // 57
    [webPages addObject:@"http://karolifeinfashion.wordpress.com"];  // 58  karolifeinfashion.wordpress.com
    [webPages addObject:@""];  // 59
    
    [webPages addObject:@""];  // 60
    [webPages addObject:@""];  // 61
    [webPages addObject:@""];  // 62
    [webPages addObject:@""];  // 63
    [webPages addObject:@""];  // 64  one has to have a lot of taste to escape the taste of one'd time
    
    [webPages addObject:@""];  // 65
    [webPages addObject:@""];  // 66
    [webPages addObject:@"http://www.sagasig.com"];  // 67  sagasig.com
    [webPages addObject:@""];  // 68
    [webPages addObject:@"http://raben-schwarz.blogspot.com"];  // 69  raben-schwarz.blogspot.com
    
    [webPages addObject:@""];  // 70
    [webPages addObject:@"http://carmenrueter.wordpress.com"];  // 71  carmenrueter.wordpress.com
    [webPages addObject:@""];  // 72 UPPER
    [webPages addObject:@"http://fashionpirates.blogspot.com"];  // 73  fashionpirates.blogspot.com
    [webPages addObject:@"http://ifthesokfitz.blogspot.com"];  // 74  ifthesokfitz.blogspot.com
    
    
    [webPages addObject:@""];  // 75 LOWER
    [webPages addObject:@""];  // 76
    [webPages addObject:@"http://jimrugg.blogspot.com"];  // 77   jimrugg.blogspot.com
    [webPages addObject:@""];  // 78
    [webPages addObject:@"http://ervehea.blogspot.com"];  // 79  ervehea.blogspot.com
    
    [webPages addObject:@""];  // 80  you can have anything you want in life if you dress for it
    [webPages addObject:@""];  // 81
    [webPages addObject:@""];  // 82
    [webPages addObject:@"http://beesandballons.blogspot.com"];  // 83  beesandballons.blogspot.com
    
    
    /////////  section 5 //////////////////////
    [webPages addObject:@"http://lefistnoir.wordpress.com"];  // 84  lefistnoir.wordpress.com
    
    [webPages addObject:@"http://www.bangsandabun.com"];  // 85  www.bangsandabun.com
    [webPages addObject:@""];  // 86
    [webPages addObject:@""];  // 87
    [webPages addObject:@""];  // 88  from the time we are born
    [webPages addObject:@""];  // 89
    
    [webPages addObject:@""];  // 90
    [webPages addObject:@""];  // 91
    [webPages addObject:@""];  // 92
    [webPages addObject:@"http://www.parkandcube.com"];  // 93  www.parkandcube.com
    [webPages addObject:@"http://www.fashionhaiku.com"];  // 94  fashionhaiku.com
    
    [webPages addObject:@""];  // 95
    [webPages addObject:@""];  // 96
    [webPages addObject:@"http://wig-wag-bam.blogspot.com"];  // 97  wig-wag-bam.blogspot.com
    [webPages addObject:@""];  // 98
    [webPages addObject:@""];  // 99
}


-(void) prepareNames {
    
    realNames =  [[NSMutableArray alloc] init];
    [realNames addObject:@"1_about.pdf"];  //0
    [realNames addObject:@""];  // the material 1
    [realNames addObject:@"1_prologue.pdf"]; // 2
    [realNames addObject:@""];  // bloggers gone wild 3
    [realNames addObject:@"1_fashionvictim.pdf"];  // 4
    
    [realNames addObject:@""];  // index 5  Fashion a topic ...
    [realNames addObject:@""];  // bloggers gone wild LOWER 6
    [realNames addObject:@"1_theartists.pdf"];  // the artists 7
    [realNames addObject:@""];  // index 8 Fashion a topic.... 8
    [realNames addObject:@"2_runthisway.pdf"]; // 9
    
    [realNames addObject:@"2_waytothetop.pdf"];  //10
    [realNames addObject:@"1_marnieweber.pdf"]; // lion pic UPPER  11
    [realNames addObject:@""]; // queen inside 12
    [realNames addObject:@"2_queeninside.pdf"]; // 13
    [realNames addObject:@"1_marnieweber.pdf"]; // lion pic LOWER 14
    
    //    [realNames addObject:@"2_projectrunaway.pdf"];  //15
    [realNames addObject:@"2_projectrunway.pdf"];  //15
    [realNames addObject:@""]; //   16
    [realNames addObject:@"2_unforgettables.pdf"]; // 17
    [realNames addObject:@"2_interviews.pdf"]; // 18
    [realNames addObject:@"2_nextdoor.pdf"]; // 19 
    
    [realNames addObject:@""];  //20  
    [realNames addObject:@"2_sizezero.pdf"]; // 21
    [realNames addObject:@""]; // 22
    [realNames addObject:@"2_jobsearch.pdf"]; // 23
    [realNames addObject:@""]; // 24
    
    
    [realNames addObject:@"2_facecanvas.pdf"];  // 25
    [realNames addObject:@"2_fashionnumbers.pdf"];  // 26
    
    ////////// section 3 /////////////
    
    [realNames addObject:@"3_woollust.pdf"];  // 27
    [realNames addObject:@""];  // 28
    [realNames addObject:@"3_7x2.pdf"];  // 29
    
    [realNames addObject:@"2_marnieweber.pdf"];  // 30
    [realNames addObject:@"3_disabled.pdf"];  // 31
    [realNames addObject:@"3_nopictures.pdf"];  // 32
    [realNames addObject:@"2_marnieweber.pdf"];  // 33
    [realNames addObject:@"3_blindacceptance.pdf"];  // 34
    
    [realNames addObject:@"3_makemeup.pdf"];  // 35
    [realNames addObject:@""];  // 36 thats the best of beauty
    [realNames addObject:@"3_roleplay.pdf"];  // 37
    [realNames addObject:@"3_lacemein.pdf"];  // 38
    [realNames addObject:@"3_patentshave.pdf"];  // 39
    
    [realNames addObject:@""];  // 40
    [realNames addObject:@"3_begyourpardon.pdf"];  // 41
    
    
    ///////////// section 4 /////////////////
    
    [realNames addObject:@"4_deformations.pdf"];  // 42
    [realNames addObject:@"4_moleosophy.pdf"];  // 43
    [realNames addObject:@""];  // 44
    
    [realNames addObject:@""];  // 45
    [realNames addObject:@"4_quinceanera.pdf"];  // 46
    [realNames addObject:@"4_uniform.pdf"];  // 47
    [realNames addObject:@"4_spirituality.pdf"];  // 48
    [realNames addObject:@"3_marnieweber.pdf"];  // 49
    
    [realNames addObject:@"4_sewingfromsoul.pdf"];  // 50
    [realNames addObject:@""];  // 51 true mystery of the world is the visible, not the invisible
    [realNames addObject:@"3_marnieweber.pdf"];  // 52
    [realNames addObject:@""];  // 53
    [realNames addObject:@""];  // 54
    
    [realNames addObject:@"4_runsinthefamily.pdf"];  // 55
    [realNames addObject:@"4_frayingaway.pdf"];  // 56
    
    
    ////////////// section 4 ////////////
    [realNames addObject:@"4_marnieweber.pdf"];  // 57
    [realNames addObject:@"5_stateofflux.pdf"];  // 58
    [realNames addObject:@""];  // 59
    
    [realNames addObject:@"4_marnieweber.pdf"];  // 60
    [realNames addObject:@""];  // 61
    [realNames addObject:@"4_fairytalefashion.pdf"];  // 62
    [realNames addObject:@"4_newsuit.pdf"];  // 63
    [realNames addObject:@""];  // 64  one has to have a lot of taste to escape the taste of one'd time
    
    [realNames addObject:@"4_allkindsoffur.pdf"];  // 65
    [realNames addObject:@""];  // 66
    [realNames addObject:@"4_thesirens.pdf"];  // 67
    [realNames addObject:@""];  // 68
    [realNames addObject:@"5_poem.pdf"];  // 69
    
    [realNames addObject:@""];  // 70
    [realNames addObject:@"5_dressupahouse.pdf"];  // 71
    [realNames addObject:@"6_marnieweber.pdf"];  // 72 UPPER
    [realNames addObject:@"5_wordstowardrobe.pdf"];  // 73
    [realNames addObject:@"5_bettyboop.pdf"];  // 74
    
    
    [realNames addObject:@"6_marnieweber.pdf"];  // 75 LOWER
    [realNames addObject:@""];  // 76
    [realNames addObject:@"5_clotheshero.pdf"];  // 77
    [realNames addObject:@""];  // 78
    [realNames addObject:@"5_factoryofdreams.pdf"];  // 79
    
    [realNames addObject:@""];  // 80  you can have anything you want in life if you dress for it
    [realNames addObject:@"5_showgirls.pdf"];  // 81
    [realNames addObject:@""];  // 82
    [realNames addObject:@"5_cleanvoyeurism.pdf"];  // 83
    
    
    /////////  section 5 //////////////////////
    [realNames addObject:@"6_fwords.pdf"];  // 84
    
    [realNames addObject:@"6_fatteningfashion.pdf"];  // 85
    [realNames addObject:@""];  // 86
    [realNames addObject:@"6_retailer.pdf"];  // 87
    [realNames addObject:@""];  // 88  from the time we are born
    [realNames addObject:@"6_fashionicon.pdf"];  // 89
    
    [realNames addObject:@"6_dessingreen.pdf"];  // 90
    [realNames addObject:@""];  // 91
    [realNames addObject:@"6_marnieweber.pdf"];  // 92
    [realNames addObject:@"6_doitmyself.pdf"];  // 93
    [realNames addObject:@"6_fourseasons.pdf"];  // 94
    
    [realNames addObject:@"6_marnieweber.pdf"];  // 95
    [realNames addObject:@""];  // 96
    [realNames addObject:@"6_ridinghood.pdf"];  // 97
    [realNames addObject:@""];  // 98
    [realNames addObject:@""];  // 99
}

-(void) prepareVidNames {
    
    vidNames =  [[NSMutableArray alloc] init];
    [vidNames addObject:@"rr.m4v"];  //0
    [vidNames addObject:@"circus-pro.m4v"];  //0
    [vidNames addObject:@"london.m4v"];  //0
}
 

// Some sample multithreading code, which can prob also use UIInterfaceOrientation instead of UIDivice
-(void)stateOfDevice:(id)param{
    if ([NSThread isMainThread]) {
        for (;;){
            if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || 
                ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) 
            {
                usleep(100000);
                [lock lock];
                [lock unlock];
            } else {

                usleep(100000);
                [lock lock];
                [lock unlock];
            }
        }
	} else {
		[self performSelectorOnMainThread:@selector(stateOfDevice) withObject:nil waitUntilDone:NO];
	}
}




@end

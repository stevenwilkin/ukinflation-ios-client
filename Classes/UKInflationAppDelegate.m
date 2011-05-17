//
//  UKInflationAppDelegate.m
//  UKInflation
//
//  Created by Steven Wilkin on 17/05/2011.
//  Copyright NullTheory Ltd 2011. All rights reserved.
//

#import "UKInflationAppDelegate.h"
#import "UKInflationViewController.h"

@implementation UKInflationAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

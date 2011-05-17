//
//  UKInflationAppDelegate.h
//  UKInflation
//
//  Created by Steven Wilkin on 17/05/2011.
//  Copyright NullTheory Ltd 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UKInflationViewController;

@interface UKInflationAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UKInflationViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UKInflationViewController *viewController;

@end


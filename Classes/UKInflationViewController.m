//
//  UKInflationViewController.m
//  UKInflation
//
//  Created by Steven Wilkin on 17/05/2011.
//  Copyright NullTheory Ltd 2011. All rights reserved.
//

#import "UKInflationViewController.h"

@implementation UKInflationViewController

@synthesize rpiLabel;
@synthesize activityIndicator;
@synthesize receivedData;

- (void)viewDidLoad {
	[rpiLabel setText:@""];	// clear RPI label before shown
	[activityIndicator setHidden:YES];
	[self restoreData];
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[rpiLabel release];
	[activityIndicator release];
    [super dealloc];
}


#pragma mark view interaction

// update the RPI label
- (void)updateRpi:(NSString *)rpi {
	[activityIndicator setHidden:YES];
	[rpiLabel setText:rpi];
}


#pragma mark data persistance

// path to the the plist containing the persisted data
- (NSString *)plistPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docsDir = [paths objectAtIndex:0];
	return [docsDir stringByAppendingPathComponent:@"data.plist"];
}

// write the data to the plist
- (void)writeData:(NSString *)rpi {
	NSDictionary *dict = [[NSDictionary alloc]
		initWithObjectsAndKeys:rpi, @"rpi", [NSDate date], @"date", nil];
	[dict writeToFile:[self plistPath] atomically:YES];
	[dict release];
}

// restore state from the plist
- (void)restoreData {
	
	NSString *plistPath = [self plistPath];
	
	// use value from plist if it exists
	if([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
		
		NSDate *date = [dict objectForKey:@"date"];
		NSString *rpi = [dict objectForKey:@"rpi"];
		
		// set the displayed value
		[self updateRpi:rpi];
		
		// if the value was retrieved more than an hour ago then refetch it
		NSTimeInterval diff = [date timeIntervalSinceNow];
		int hours = abs((int)(diff / (60 * 60)));
		
		if(hours >= 1) {
			[self fetchRpi];
		}

	} else {	// call web service
		[self fetchRpi];
	}

}


#pragma mark web service interaction

- (void)fetchRpi {
	// show activity indicator
	[activityIndicator setHidden:NO];
	
	receivedData = [[NSMutableData alloc] init];
	
	NSURL *url = [NSURL URLWithString:@"http://ukinflation.appspot.com/rpi.json"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[connection release];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // handle error
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// receivedData contains the complete result
	NSDictionary *dict = [receivedData objectFromJSONData];
	NSString *rpi = [dict objectForKey:@"rpi"];

	// save data
	[self writeData:rpi];
	// update view
	[self updateRpi:rpi];

	[receivedData release];
}

@end
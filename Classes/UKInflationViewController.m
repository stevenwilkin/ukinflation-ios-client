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
    [super viewDidLoad];
	[self fetchRpi];
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
	
	// hide activity indicator and display rpi value
	[activityIndicator setHidden:YES];
	[rpiLabel setText:rpi];
	[receivedData release];
}

@end
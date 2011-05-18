//
//  UKInflationViewController.h
//  UKInflation
//
//  Created by Steven Wilkin on 17/05/2011.
//  Copyright NullTheory Ltd 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"

@interface UKInflationViewController : UIViewController {

	IBOutlet UILabel *rpiLabel;
	NSMutableData *receivedData;
	
}

@property (retain, nonatomic) UILabel *rpiLabel;
@property (retain, nonatomic) NSMutableData *receivedData;

- (void)fetchRpi;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
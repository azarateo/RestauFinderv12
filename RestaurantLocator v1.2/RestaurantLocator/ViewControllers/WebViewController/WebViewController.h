//
//  WebViewController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView* webView;

@property (nonatomic, retain) NSString* urlString;

-(IBAction)didClickRefreshButton:(id)sender;

@end

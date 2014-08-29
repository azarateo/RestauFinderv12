//
//  WebViewController.m
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView;
@synthesize urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    
    if(![MGUtilities hasInternetConnection]) {
        [MGUtilities showAlertTitle:@"Network Error" message:@"No Network connection."];
        return;
    }
    
    [self didClickRefreshButton:self];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MGUtilities showAlertTitle:@"Website Error" message:@"Loading problem due to network errors."];
    NSLog(@"%@", error.localizedDescription);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {

}

-(void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didClickRefreshButton:(id)sender {
    NSRange rangeHttp = [urlString rangeOfString : @"http://"];
    NSRange rangeHttps = [urlString rangeOfString : @"https://"];
    NSString* newUrlStr = nil;
    
    if(rangeHttp.location == NSNotFound)
        newUrlStr = [@"http://" stringByAppendingString:urlString];
    
    else if(rangeHttps.location == NSNotFound && newUrlStr == nil)
        newUrlStr = [@"https://" stringByAppendingString:urlString];
    
    else
        newUrlStr = urlString;
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:newUrlStr]];
    [webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

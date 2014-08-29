//
//  FeaturedViewController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedViewController : UIViewController <MGListViewDelegate> {
    
}

@property (nonatomic, retain) IBOutlet MGListView* listView;

-(IBAction)didClickBarButtonFave:(id)sender;
-(IBAction)didClickBarButtonHome:(id)sender;

@end

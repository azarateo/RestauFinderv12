//
//  RestaurantViewController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantViewController : UIViewController <MGListViewDelegate>

@property (nonatomic, retain) IBOutlet MGListView* listView;

@property (nonatomic, retain) Category1* category;
@property (nonatomic, retain) NSMutableArray* arrayData;

-(IBAction)didClickBarButtonFave:(id)sender;

@end

//
//  FavoritesViewController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController <MGListViewDelegate>

@property (nonatomic, retain) IBOutlet MGListView* listView;

@end

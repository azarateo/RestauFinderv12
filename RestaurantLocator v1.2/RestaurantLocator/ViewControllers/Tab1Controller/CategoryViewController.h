//
//  RestaurantViewController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController <MGListViewDelegate, MGSliderDelegate> {
    NSArray* _arraySlider;
}

@property (nonatomic, retain) IBOutlet MGListView* listView;
@property (nonatomic, retain) IBOutlet MGSlider* slider;

-(IBAction)didClickBarButtonFave:(id)sender;

-(IBAction)didClickBarButtonHome:(id)sender;

@end

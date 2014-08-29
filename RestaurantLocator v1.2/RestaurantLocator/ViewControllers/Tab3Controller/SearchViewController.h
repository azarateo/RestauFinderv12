//
//  SearchViewController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <RateViewDelegate, UIPickerActionSheetDelegate, UITextFieldDelegate>
{
    UIPickerActionSheet* _pickerActionSheetCategories;
    NSMutableArray* _categoryArray;
    MGRawView* _searchView;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollView;

-(IBAction)didClickBarButtonFave:(id)sender;
-(IBAction)didClickBarButtonHome:(id)sender;


@end

//
//  ImageViewerController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewerController : UIViewController <MGImageViewerDelegate>

@property (nonatomic, retain) IBOutlet MGImageViewer* imageViewer;
@property (nonatomic, retain) NSArray* imageArray;
@property (nonatomic, assign) int selectedIndex;

-(IBAction)didClickBarButtonFave:(id)sender;

@end

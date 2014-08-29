//
//  GalleryViewController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryViewController : UIViewController<MGGalleryViewDelegate> {
    NSMutableArray* _photoArray;
}

@property (nonatomic, retain) IBOutlet MGGalleryView* galleryView;

-(IBAction)didClickBarButtonFave:(id)sender;
-(IBAction)didClickBarButtonHome:(id)sender;

@end

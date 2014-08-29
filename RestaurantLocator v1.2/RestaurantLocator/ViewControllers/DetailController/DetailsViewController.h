//
//  DetailsViewController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <MGNestedTabDelegate, MGGalleryViewDelegate, MGMapViewDelegate, MFMailComposeViewControllerDelegate> {
    MGRawView* _detailView;
    MGMapView* _mapView;
    MGGalleryView* _galleryView;
    UIScrollView* _scrollView;
    
    NSArray* _arrayPhotos;
    Favorite* _fave;
    int _selectedIndex;
}

@property (nonatomic, retain) IBOutlet UIImageView* imgViewPic;
@property (nonatomic, retain) IBOutlet MGNestedTab* nestedTab;
@property (nonatomic, retain) IBOutlet UIView* viewHolder;
@property (nonatomic, retain) Restaurant* restaurant;

@property (nonatomic, retain) IBOutlet UIBarButtonItem* barButtonFaveAddDel;

-(IBAction)didClickBarButtonFavorite:(id)sender;

@end

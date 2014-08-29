//
//  MapViewController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController <MGMapViewDelegate, CLLocationManagerDelegate> {
    NSMutableArray* _arrayData;
    CLLocationManager* _myLocationManager;
    CLLocation* _myLocation;
    MGMapAnnotation* _selectedAnnotation;
    BOOL _centerOnce;
}

@property (nonatomic, retain) IBOutlet UIButton* buttonLocation;
@property (nonatomic, retain) IBOutlet UIButton* buttonRoute;
@property (nonatomic, retain) IBOutlet UIButton* buttonMapAllPins;

@property (nonatomic, retain) IBOutlet UILabel* labelDistance;

@property (nonatomic, retain) IBOutlet MGMapView* mapView;

-(IBAction)didClickBarButtonFave:(id)sender;

-(IBAction)didClickBarButtonLocation:(id)sender;
-(IBAction)didClickBarButtonRoute:(id)sender;
-(IBAction)didClickBarButtonHome:(id)sender;
-(IBAction)didClickBarButtonAllMapPins:(id)sender;

@end

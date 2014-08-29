//
//  MapViewController.m
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import "MapViewController.h"
#import "DetailsViewController.h"
#import "FavoritesViewController.h"
#import "AppDelegate.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;
@synthesize buttonLocation;
@synthesize buttonRoute;
@synthesize buttonMapAllPins;
@synthesize labelDistance;

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
    
    mapView.delegate = self;
    [mapView baseInit];
    
    [self beginParsing];
    
    buttonRoute.enabled = NO;
    
    labelDistance.text = @"0.0 Km";
    labelDistance.textColor = THEME_COLOR;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) MGMapView:(MGMapView*)mapView didSelectMapAnnotation:(MGMapAnnotation*)mapAnnotation {
    _selectedAnnotation = mapAnnotation;
    buttonRoute.enabled = YES;
}

-(void) MGMapView:(MGMapView*)mapView didAccessoryTapped:(MGMapAnnotation*)mapAnnotation {
    
}

-(void) MGMapView:(MGMapView*)mapView didCreateMKPinAnnotationView:(MKPinAnnotationView*)mKPinAnnotationView viewForAnnotation:(id<MKAnnotation>)annotation {

    mKPinAnnotationView.image = [UIImage imageNamed:MAP_PIN];

    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage* imageAnnotation = [UIImage imageNamed:MAP_ARROW_RIGHT];
    [imageView setImage:imageAnnotation];

    imageView.frame = CGRectMake (0, 0, imageAnnotation.size.width, imageAnnotation.size.height);
    mKPinAnnotationView.rightCalloutAccessoryView = imageView;

    UITapGestureRecognizer* tap = nil;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapRightAccesoryButton:)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = YES;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
    
}

-(MKOverlayView*)MGMapView:(MGMapView *)mapView viewForOverlay:(id)overlay {
    
    return nil;
}

-(MKOverlayRenderer*)MGMapView:(MGMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer * lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.lineWidth = 3.0f;
        lineView.strokeColor = THEME_COLOR;
        
        return lineView;
    }
    
    return nil;
}


-(void)didTapRightAccesoryButton:(id)sender {
    
    MGMapAnnotation* ann = mapView.currentAnnotation;
    [self performSegueWithIdentifier:@"segueDetails" sender:ann.object];
}

-(void)beginParsing {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    [self.view addSubview:hud];
	
    //    __weak typeof(slider) weakSlider = slider;
    
    [self.view setUserInteractionEnabled:NO];
	[hud showAnimated:YES whileExecutingBlock:^{
        
		[self performParsing];
        
	} completionBlock:^{
        
		[hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        [self findMyCurrentLocation];
        [mapView zoomAndFitAnnotations];
        
	}];
    
}

-(void) performParsing {
    
    if(_arrayData == nil)
        _arrayData = [NSMutableArray new];
    
    [_arrayData removeAllObjects];
    
    NSArray* array = [CoreDataController getRestaurants];
    _arrayData = [ NSMutableArray arrayWithArray:array];
    
    NSMutableArray* arrayMapAnnotations = [NSMutableArray new];
    
    for(Restaurant* res in array) {
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([res.lat doubleValue], [res.lon doubleValue]);
        MGMapAnnotation* ann = [[MGMapAnnotation alloc] initWithCoordinate:coords name:res.name description:res.desc];
        
        ann.object = res;
        [arrayMapAnnotations addObject:ann];
    }
    [mapView setMapData:arrayMapAnnotations];
    
}

#pragma mark - find current location via location service

-(void)findMyCurrentLocation {
    if(_myLocationManager == nil) {
        _myLocationManager = [[CLLocationManager alloc] init];
        _myLocationManager.delegate = self;
        [mapView.mapView setShowsUserLocation:YES];
        [_myLocationManager startUpdatingLocation];
        
        if( [CLLocationManager locationServicesEnabled] ) {
            NSLog(@"Location Services Enabled....");
        }
        else {
            [MGUtilities showAlertTitle:@"Location Service Error"
                                message:@"Location service is not enable. Please enable it from settings."];
        }
    }
    else {
        [_myLocationManager startUpdatingLocation];
    }
    
    
}

#pragma mark - location manager delegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation: (CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    _myLocation = newLocation;
    
    if(!_centerOnce) {
        [mapView.mapView setCenterCoordinate:newLocation.coordinate animated:YES];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 3.0 * METES_PER_MILE, 3.0 * METES_PER_MILE);
        MKCoordinateRegion adjustedRegion = [mapView.mapView regionThatFits:viewRegion];
        [mapView.mapView setRegion:adjustedRegion animated:YES];
        _centerOnce = YES;
    }
    
    if(_selectedAnnotation != nil) {
        [self getDistance];
    }
    
//    [_myLocationManager stopUpdatingLocation];
}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    [MGUtilities showAlertTitle:@"Location Error"
                        message:@"Cannot fetch location."];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueDetails"]) {
        DetailsViewController* restaurant = (DetailsViewController*)[segue destinationViewController];
        restaurant.restaurant = (Restaurant*)sender;
    }
}

-(IBAction)didClickBarButtonFave:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    FavoritesViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyBoardFavorites"];
    [self.navigationController pushViewController:viewController animated:YES];

}

-(IBAction)didClickBarButtonLocation:(id)sender {
    _centerOnce = NO;
}

-(IBAction)didClickBarButtonRoute:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        [MGUtilities showAlertTitle:@"Network Error" message:@"No network connection."];
        return;
    }
    
    if(_myLocation == nil) {
        [MGUtilities showAlertTitle:@"User Location Error" message:@"Cannot determine route because user cannot detect its location"];
        return;
    }
    
    if(_selectedAnnotation == nil) {
        [MGUtilities showAlertTitle:@"Map Pin Error" message:@"Cannot determine route because user havent selected any map pin."];
        return;
    }
    
    for (id<MKOverlay> overlay in [mapView.mapView overlays]) {
        if ([overlay isKindOfClass:[MKPolyline class]]) {
            [mapView.mapView removeOverlay:overlay];
        }
    }
    
    [self beginParsingRoute];
    
    
}


-(IBAction)didClickBarButtonAllMapPins:(id)sender {
    [mapView zoomAndFitAnnotations];
}


-(void)beginParsingRoute {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Creating Routes...";
    
    [self.view addSubview:hud];
	
    NSMutableArray* routeArray = [NSMutableArray new];
    __strong typeof(NSMutableArray*) strongRouteArray = routeArray;
    
    [self.view setUserInteractionEnabled:NO];
	[hud showAnimated:YES whileExecutingBlock:^{
        
		[self performParseRoute:strongRouteArray];
        
	} completionBlock:^{
        
		[hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        [self displayOverlay:strongRouteArray];
        
	}];
    
}

-(void)performParseRoute:(NSMutableArray*)routeArray {
    
    NSArray* array = [MGMapRoute getRouteFrom:_myLocation.coordinate to:_selectedAnnotation.coordinate];
    
    for(id entry in array) {
        [routeArray addObject:entry];
    }
}

-(void)displayOverlay:(NSMutableArray*)routeArray {
    
    NSInteger routeCount = routeArray.count;
    CLLocationCoordinate2D coordsArray[routeCount];
    
    if(routeCount > 0) {
        for(int i = 0; i < routeCount; i++) {
            
            CLLocation* location = [routeArray objectAtIndex:i];
            coordsArray[i] = location.coordinate;
        }
        
        MKPolyline* routePolyLine = [MKPolyline polylineWithCoordinates:coordsArray count:routeCount];
        [mapView.mapView addOverlay:routePolyLine];
    }
}

-(void)getDistance {
    
    CLLocationCoordinate2D coord = _selectedAnnotation.coordinate;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude
                                                      longitude:coord.longitude];
    
    double distance = [_myLocation distanceFromLocation:location] / 1000;
    labelDistance.text = [NSString stringWithFormat:@"%.02f Km", distance];
}

-(IBAction)didClickBarButtonHome:(id)sender {
    AppDelegate* delegate = [AppDelegate instance];
    UITabBarController *tabBar = (UITabBarController *)delegate.window.rootViewController;
    [tabBar setSelectedIndex:0];
}


@end

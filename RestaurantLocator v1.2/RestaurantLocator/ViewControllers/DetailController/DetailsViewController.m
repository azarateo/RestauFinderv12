//
//  DetailsViewController.m
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import "DetailsViewController.h"
#import "ImageViewerController.h"
#import "WebViewController.h"
#import "AppDelegate.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize nestedTab;
@synthesize viewHolder;
@synthesize imgViewPic;
@synthesize restaurant;
@synthesize barButtonFaveAddDel;

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
    
    
    CGRect innerRect = CGRectMake(0, 0, viewHolder.frame.size.width, viewHolder.frame.size.height);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:innerRect];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delaysContentTouches = NO;
    
    _detailView = [[MGRawView alloc] initWithFrame:innerRect nibName:@"DetailAboutView"];
    _detailView.topLeftLabelAddress.text = [restaurant.address stringByDecodingXMLEntities];
    _detailView.topLeftLabelAddress.textColor = LIST_TEXT_COLOR;
    
    _detailView.topLeftLabelAmenities.text = [restaurant.amenities stringByDecodingXMLEntities];
    _detailView.topLeftLabelAmenities.textColor = LIST_TEXT_COLOR;
    
    _detailView.topLeftLabelDescription.text = [restaurant.desc stringByDecodingXMLEntities];
    _detailView.topLeftLabelDescription.textColor = LIST_TEXT_COLOR;
    
    _detailView.labelWorkingHours.text = [restaurant.hours stringByDecodingXMLEntities];
    _detailView.labelWorkingHours.textColor = LIST_TEXT_COLOR;
    
    _detailView.labelTitle.text = [restaurant.name stringByDecodingXMLEntities];
    _detailView.labelTitle.textColor = THEME_COLOR;
    
    _detailView.ratingViewFood.notSelectedImage = [UIImage imageNamed:RATING_STAR_EMPTY];
    _detailView.ratingViewFood.halfSelectedImage = [UIImage imageNamed:RATING_STAR_HALF];
    _detailView.ratingViewFood.fullSelectedImage = [UIImage imageNamed:RATING_STAR_FULL];
    _detailView.ratingViewFood.rating = 1.0;
    _detailView.ratingViewFood.editable = NO;
    _detailView.ratingViewFood.maxRating = 5;
    _detailView.ratingViewFood.midMargin = 0;
    [_detailView.ratingViewFood setRating:[restaurant.food_rating intValue]];
    
    
    _detailView.ratingViewPrice.notSelectedImage = [UIImage imageNamed:RATING_STAR_EMPTY];
    _detailView.ratingViewPrice.halfSelectedImage = [UIImage imageNamed:RATING_STAR_HALF];
    _detailView.ratingViewPrice.fullSelectedImage = [UIImage imageNamed:RATING_STAR_FULL];
    _detailView.ratingViewPrice.rating = 1.0;
    _detailView.ratingViewPrice.editable = NO;
    _detailView.ratingViewPrice.maxRating = 5;
    _detailView.ratingViewPrice.midMargin = 0;
    [_detailView.ratingViewPrice setRating:[restaurant.price_rating intValue]];
    
    
    [_detailView.buttonCall addTarget:self
                               action:@selector(didClickCallButton:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [_detailView.buttonEmail addTarget:self
                                action:@selector(didClickEmailButton:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [_detailView.buttonWeb addTarget:self
                              action:@selector(didClickWebsiteButton:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    
    [_scrollView addSubview:_detailView];
    
    
    CGRect frameMap = CGRectMake(0, 0, viewHolder.frame.size.width, viewHolder.frame.size.height);
    _mapView = [[MGMapView alloc] initWithFrame:frameMap];
    _mapView.delegate = self;
    _mapView.mapView.frame = frameMap;
    [_mapView baseInit];
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([restaurant.lat doubleValue], [restaurant.lon doubleValue]);
    MGMapAnnotation* ann = [[MGMapAnnotation alloc] initWithCoordinate:coords name:restaurant.name description:restaurant.desc];
    ann.object = restaurant;
 
    
    [_mapView setMapData:[NSMutableArray arrayWithObjects:ann, nil] ];
    [_mapView setSelectedAnnotation:coords];

    
    _galleryView = [[MGGalleryView alloc] initWithFrame:innerRect nibName:@"GalleryView"];
    _galleryView.galleryDelegate = self;
    _galleryView.numberOfColumns = 4;
    _galleryView.spacing = 4;
    _galleryView.height = 75;
    
    
    _arrayPhotos = [CoreDataController getPhotosByRestaurantId:[restaurant.restaurant_id intValue]];
    _galleryView.numberOfItems = _arrayPhotos.count;
    
    [nestedTab baseInit];
    nestedTab.titles = INNER_TAB_TITLE;
    nestedTab.arraySelectedImages = [NSArray arrayWithObjects:INNER_TAB_LEFT_SELECTED, INNER_TAB_MIDDLE_SELECTED, INNER_TAB_RIGHT_SELECTED, nil];
    nestedTab.arrayUnselectedImages = [NSArray arrayWithObjects:INNER_TAB_LEFT, INNER_TAB_MIDDLE, INNER_TAB_RIGHT, nil];
    
    nestedTab.selectedTextColor = [UIColor whiteColor];
    nestedTab.normalTextColor = [UIColor whiteColor];
    [nestedTab setButtonFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [nestedTab setNeedsReLayout];
    
    nestedTab.delegate = self;
    [nestedTab setSelectedTab:0];
    
    [self setPhotoAbove];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkFave];
}

-(void)setPhotoAbove {
    
    Photo* photo = [CoreDataController getPhotoByRestaurantId:[restaurant.restaurant_id intValue]];
    NSURL* url = [NSURL URLWithString:photo.photo_url];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgViewPic) weakImgRef = imgViewPic;
    UIImage* imgPlaceholder = [UIImage imageNamed:SLIDER_PLACEHOLDER_IMAGE];
    
    
    [imgViewPic setImageWithURLRequest:urlRequest placeholderImage:imgPlaceholder
          success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
              
              CGSize size = weakImgRef.frame.size;
              
              if([MGUtilities isRetinaDisplay]) {
                  size.height *= 2;
                  size.width *= 2;
              }
              
              UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
              weakImgRef.image = croppedImage;
              
          } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
          
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) MGGalleryView:(MGGalleryView *)galleryView didCreateView:(MGRawView *)rawView atIndex:(int)index {
    Photo* photo = [_arrayPhotos objectAtIndex:index];
    
    NSURL* url = [NSURL URLWithString:photo.thumb_url];

    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    
    __weak typeof(rawView.imgViewThumb ) weakImgRef = rawView.imgViewThumb;
    UIImage* imgPlaceholder = [UIImage imageNamed:GALLERY_THUMB_PLACEHOLDER_IMAGE];
    
    
    [rawView.imgViewThumb setImageWithURLRequest:urlRequest placeholderImage:imgPlaceholder
         success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
             
             CGSize size = weakImgRef.frame.size;
             
             if([MGUtilities isRetinaDisplay]) {
                 size.height *= 2;
                 size.width *= 2;
             }
             
             UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
             weakImgRef.image = croppedImage;
             
             [MGUtilities createBorders:weakImgRef
                            borderColor:THEME_COLOR
                            shadowColor:WHITE_TEXT_COLOR
                            borderWidth:3.0
                           borderRadius:6.0f];
             
         } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
             
         }];
    
    rawView.buttonCustom.tag = index;
    [rawView.buttonCustom addTarget:self
                             action:@selector(didButtonClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)didButtonClicked:(id)sender {
    
    _selectedIndex = (int)((UIButton*)sender).tag;
    [self performSegueWithIdentifier:@"segueImageViewer"
                              sender:[NSMutableArray arrayWithArray:_arrayPhotos]];
}

-(void) MGNestedTab:(MGNestedTab *)nestedTab didCreateTabButton:(UIButton *)button indexTab:(int)index {
    
}

-(void) MGNestedTab:(MGNestedTab *)_nestedTab didSelectTabButton:(UIButton *)button indexTab:(int)index {
    
    for(UIView* view in viewHolder.subviews) {
        [view removeFromSuperview];
    }
    
    
    switch (index) {
        case 0:
            [viewHolder addSubview:_scrollView];
            _scrollView.contentSize = _detailView.frame.size;
            break;
            
        case 1:
            [viewHolder addSubview:_mapView];
            
            break;
            
        case 2:
            [viewHolder addSubview:_galleryView];
//            scrollView.contentSize = _galleryView.frame.size;
            [_galleryView setNeedsHorizontalReLayout];
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark - MAP Delegate

-(void) MGMapView:(MGMapView*)mapView didSelectMapAnnotation:(MGMapAnnotation*)mapAnnotation {
    
}

-(void) MGMapView:(MGMapView*)mapView didAccessoryTapped:(MGMapAnnotation*)mapAnnotation {
    
}

-(void) MGMapView:(MGMapView*)mapView didCreateMKPinAnnotationView:(MKPinAnnotationView*)mKPinAnnotationView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage* imageAnnotation = [UIImage imageNamed:MAP_ARROW_RIGHT];
    [imageView setImage:imageAnnotation];
    
    mKPinAnnotationView.image = [UIImage imageNamed:MAP_PIN];
    
    imageView.frame = CGRectMake (0, 0, imageAnnotation.size.width, imageAnnotation.size.height);
    mKPinAnnotationView.rightCalloutAccessoryView = imageView;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueImageViewer"]) {
        
        ImageViewerController* imageViewer = (ImageViewerController*)[segue destinationViewController];
        imageViewer.imageArray = sender;
        imageViewer.selectedIndex = _selectedIndex;
    }
    
    if([[segue identifier] isEqualToString:@"segueWeb"]) {
        
        WebViewController* webController = (WebViewController*)[segue destinationViewController];
        webController.urlString = sender;
    }
}


#pragma mark - CALL BUTTON

-(void)didClickCallButton:(id)sender {
    
    NSString* phone = [restaurant.phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone] ]];
}

#pragma mark - EMAIL BUTTON

-(void)didClickEmailButton:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        
        // set the sendTo address
        NSMutableArray *recipients = [[NSMutableArray alloc] initWithCapacity:1];
        [recipients addObject:restaurant.email];
        
        MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        
        [mailController setSubject:@"Restaurant Inquiry"];
        
        NSString* formattedBody = @"Message goes here...";
        
        [mailController setMessageBody:formattedBody isHTML:NO];
        [mailController setToRecipients:recipients];
        
        if(DOES_SUPPORT_IOS7) {
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        WHITE_TEXT_COLOR, NSForegroundColorAttributeName, nil];
            
            [[mailController navigationBar] setTitleTextAttributes:attributes];
            [[mailController navigationBar ] setTintColor:[UIColor whiteColor]];
            
        }
 
        [self.navigationController presentViewController:mailController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    else {
        [MGUtilities showAlertTitle:@"Email Service Error" message:@"Your device doesnt support email service."];
    }

}

#pragma mark - WEBSITE BUTTON

-(void)didClickWebsiteButton:(id)sender {
    [self performSegueWithIdentifier:@"segueWeb" sender:restaurant.website];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self becomeFirstResponder];
	[self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)didClickBarButtonFavorite:(id)sender {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    if(_fave == nil) {
        NSString* className = NSStringFromClass([Favorite class]);
        NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
        Favorite* fave = (Favorite*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        fave.restaurant_id = restaurant.restaurant_id;
        
        NSError* error;
        if ([delegate.managedObjectContext hasChanges] && ![delegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else {
        [context deleteObject:_fave];
        
        NSError* error;
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    [self checkFave];
        
}

-(void)checkFave {
    // barbutton item
    _fave = [CoreDataController getFavoriteByRestaurantId:[restaurant.restaurant_id intValue]];
    
    if(_fave == nil)
        barButtonFaveAddDel.image = [UIImage imageNamed:ICON_FAVORITE_ADD];
    else
        barButtonFaveAddDel.image = [UIImage imageNamed:ICON_FAVORITE_REMOVE];
}



@end

//
//  GalleryViewController.m
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import "GalleryViewController.h"
#import "AFImageRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "MGUIImageExtras.h"
#import "ImageViewerController.h"
#import "FavoritesViewController.h"
#import "AppDelegate.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

@synthesize galleryView;

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
    
    
    galleryView.galleryDelegate = self;
    galleryView.numberOfColumns = 4;
    galleryView.spacing = 4;
    galleryView.height = 75;
    galleryView.nibName = @"GalleryView";
    
    _photoArray = [NSMutableArray arrayWithArray:[CoreDataController getPhotos]];
    
    galleryView.numberOfItems = _photoArray.count;
    [galleryView setNeedsHorizontalReLayout];
}

-(void) MGGalleryView:(MGGalleryView *)galleryView didCreateView:(MGRawView *)rawView atIndex:(int)index {
    Photo* photo = [_photoArray objectAtIndex:index];
    
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
         
         [MGUtilities createBorders:weakImgRef
                        borderColor:THEME_COLOR
                        shadowColor:WHITE_TEXT_COLOR
                        borderWidth:3.0
                       borderRadius:6.0f];
     }];
    
    rawView.buttonCustom.tag = index;
    [rawView.buttonCustom addTarget:self
                             action:@selector(didButtonClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)didButtonClicked:(id)sender {
    
    UIButton* button = (UIButton*)sender;
    [self performSegueWithIdentifier:@"segueImageViewer" sender:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueImageViewer"]) {
        
        ImageViewerController* imageViewer = (ImageViewerController*)[segue destinationViewController];
        imageViewer.imageArray = _photoArray;
        imageViewer.selectedIndex = (int)[((UIButton*)sender) tag];
    }
}

-(IBAction)didClickBarButtonFave:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    FavoritesViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyBoardFavorites"];
    [self.navigationController pushViewController:viewController animated:YES];

}


-(IBAction)didClickBarButtonHome:(id)sender {
    AppDelegate* delegate = [AppDelegate instance];
    UITabBarController *tabBar = (UITabBarController *)delegate.window.rootViewController;
    [tabBar setSelectedIndex:0];
}

@end

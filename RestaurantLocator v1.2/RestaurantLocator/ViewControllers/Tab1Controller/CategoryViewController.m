//
//  RestaurantViewController.m
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import "CategoryViewController.h"
#import "AppDelegate.h"
#import "RestaurantViewController.h"
#import "FavoritesViewController.h"
#import "AppDelegate.h"
#import "DetailsViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

@synthesize listView;
@synthesize slider;

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
    
    
    listView.delegate = self;
    listView.cellHeight = 50;
    
    slider.nibName = @"SliderView";
    slider.delegate = self;
    
    [listView registerNibName:@"CategoryCell" cellIndentifier:@"CategoryCell"];
    [listView baseInit];
    
    NSArray* restaurantsArray = [CoreDataController getRestaurants];
    if(![MGUtilities hasInternetConnection] && (restaurantsArray == nil || [restaurantsArray count] == 0) ) {
        [MGUtilities showAlertTitle:@"Network Error" message:@"No network connection. Cannnot download data."];
        return;
    }
    
    [self beginParsing];
}


-(void)beginParsing {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
	[hud showAnimated:YES whileExecutingBlock:^{
        
		[self performParsing];
        
	} completionBlock:^{
        
		[hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [self getCategories];
        [self setFeaturedRestaurants];
        [listView reloadData];
	}];
    
}

-(void) performParsing {
    
    if(WILL_DOWNLOAD_DATA && [MGUtilities hasInternetConnection]) {
        
        AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext* context = delegate.managedObjectContext;
        
        [CoreDataController deleteAllObjects:@"Restaurant"];
        [CoreDataController deleteAllObjects:@"Category1"];
        [CoreDataController deleteAllObjects:@"Photo"];
        
        @try {
            NSMutableArray* arrayData;
            if(WILL_USE_JSON_FORMAT) {
                arrayData = [DataParser parseDataFromURLFormatJSON:DATA_JSON_URL];
            }
            else {
                arrayData = [DataParser parseDataFromURLFormatXML:DATA_XML_URL];
            }
            
            if(arrayData != nil && arrayData.count > 0) {
                NSError *error;
                if ([context hasChanges] && ![context save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"exception = %@", exception.debugDescription);
        }
        
    }
    
}

-(void)getCategories {
    
    if(listView.arrayData == nil)
        listView.arrayData = [NSMutableArray new];
    
    [listView.arrayData removeAllObjects];
    listView.arrayData = [NSMutableArray arrayWithArray:[CoreDataController getCategories]];
}

-(void) setFeaturedRestaurants {
    _arraySlider = [CoreDataController getFeaturedRestaurants];
    slider.numberOfItems = _arraySlider.count;
    
    [slider setNeedsReLayoutWithViewSize:CGSizeMake(self.view.frame.size.width, slider.frame.size.height)];
    [slider startAnimationWithDuration:4.0f];
    
//    [slider showPageControl:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueRestaurant"
                              sender:[listView.arrayData objectAtIndex:indexPath.row]];
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        Category1* res = [listView.arrayData objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.labelTitle setText:[res.category stringByDecodingXMLEntities]];
        
        
        
        cell.selectedColor = THEME_COLOR;
        cell.unSelectedColor = LIST_TEXT_COLOR;
        
        UIImage* unSelected = [UIImage imageNamed:CATEGORY_LIST_BG];
        UIImage* selected = [UIImage imageNamed:CATEGORY_LIST_BG_SELECTED];
        cell.selectedImage = selected;
        cell.unselectedImage = unSelected;
        cell.unselectedImageArrow = [UIImage imageNamed:LIST_ARROW_NORMAL];
        cell.selectedImageArrow = [UIImage imageNamed:LIST_ARROW_SELECTED];
    }
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"segueRestaurant"]) {
        RestaurantViewController* restaurant = (RestaurantViewController*)[segue destinationViewController];
        restaurant.category = (Category1*)sender;
    }
    
}



#pragma mark - SLIDER

-(void) MGSlider:(MGSlider *)slider didCreateSliderView:(MGRawView *)rawView atIndex:(int)index {
    
    Restaurant* res = [_arraySlider objectAtIndex:index];
    Photo* photo = [CoreDataController getPhotoByRestaurantId:[res.restaurant_id intValue] ];
    NSString* strPhoto = [NSString stringWithFormat:@"%@", photo.photo_url];
    
    [rawView.labelTitle setText:[res.name stringByDecodingXMLEntities]];
    [rawView.labelSubtitle setText:[res.address stringByDecodingXMLEntities]];
    
    
    if(photo != nil) {
        NSURL* url = [NSURL URLWithString:strPhoto];
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
        
        __weak typeof(rawView.imgViewThumb ) weakImgRef = rawView.imgViewThumb;
        UIImage* imgPlaceholder = [UIImage imageNamed:SLIDER_PLACEHOLDER_IMAGE];
        
        
        [rawView.imgViewThumb setImageWithURLRequest:urlRequest
                                    placeholderImage:imgPlaceholder
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
    
    [rawView.buttonCustom setTag:index];
    [rawView.buttonCustom addTarget:self
                             action:@selector(didClickSlider:)
                   forControlEvents:UIControlEventTouchUpInside];
}

-(void) MGSlider:(MGSlider *)slider didPageControlClicked:(UIButton *)rawView atIndex:(int)index {
    
}

-(void) MGSlider:(MGSlider *)slider didSelectSliderView:(MGRawView *)rawView atIndex:(int)index {
    
}

-(void)didClickSlider:(id)sender {
    
    UIButton* button = (UIButton*)sender;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DetailsViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyBoardDetails"];
    viewController.restaurant = [_arraySlider objectAtIndex:button.tag];
    [self.navigationController pushViewController:viewController animated:YES];
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

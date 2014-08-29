//
//  FeaturedViewController.m
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import "FeaturedViewController.h"
#import "DetailsViewController.h"
#import "FavoritesViewController.h"
#import "AppDelegate.h"

@interface FeaturedViewController ()

@end

@implementation FeaturedViewController

@synthesize listView;

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
    listView.cellHeight = 65;
    
    [listView registerNibName:@"RestaurantCell" cellIndentifier:@"RestaurantCell"];
    [listView baseInit];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
        [listView reloadData];
	}];
    
}

-(void)performParsing {
    listView.arrayData = [NSMutableArray arrayWithArray:[CoreDataController getFeaturedRestaurants]];
}

-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueDetails"
                              sender:[listView.arrayData objectAtIndex:indexPath.row]];
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        Restaurant* res = [listView.arrayData objectAtIndex:indexPath.row];
        Photo* photo = [CoreDataController getPhotoByRestaurantId:[res.restaurant_id intValue]];
        Favorite* fave = [CoreDataController getFavoriteByRestaurantId:[res.restaurant_id intValue]];
        
        if(fave != nil)
            [cell.imgViewPic setImage:[UIImage imageNamed:ICON_LIST_FAVORITE_BADGE]];
        else
            [cell.imgViewPic setImage:[[UIImage alloc] init]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.labelTitle setText:[res.name stringByDecodingXMLEntities]];
        [cell.topLeftLabelSubtitle setText:[res.desc stringByDecodingXMLEntities]];

        
        [cell.topLeftLabelSubtitle setTextColor:NORMAL_COLOR];
        
        cell.selectedColor = THEME_COLOR;
        cell.unSelectedColor = LIST_TEXT_COLOR;
        
        UIImage* unSelected = [UIImage imageNamed:LIST_BG];
        UIImage* selected = [UIImage imageNamed:LIST_BG_SELECTED];
        cell.selectedImage = selected;
        cell.unselectedImage = unSelected;
        cell.unselectedImageArrow = [UIImage imageNamed:LIST_ARROW_NORMAL];
        cell.selectedImageArrow = [UIImage imageNamed:LIST_ARROW_SELECTED];
        
        if([res.featured isEqualToString:@"1"])
            [cell.imgViewFeatured setImage:[UIImage imageNamed:FEATURED_BADGE]];
        
        [self setThumbnailPhoto:photo.thumb_url MGListCell:cell];
    }
    
    return cell;
}

-(void)setThumbnailPhoto:(NSString*)photoName MGListCell:(MGListCell*) cell {
    
    NSURL* url = [NSURL URLWithString:photoName];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(cell.imgViewThumb ) weakImgRef = cell.imgViewThumb;
    UIImage* imgPlaceholder = [UIImage imageNamed:RESTAURANT_THUMB_PLACEHOLDER_IMAGE];
    
    
    [cell.imgViewThumb setImageWithURLRequest:urlRequest placeholderImage:imgPlaceholder
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
                        borderWidth:2.0
                       borderRadius:4.0f];
         
    
         
     } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
         
         [MGUtilities createBorders:weakImgRef
                        borderColor:THEME_COLOR
                        shadowColor:WHITE_TEXT_COLOR
                        borderWidth:2.0
                       borderRadius:4.0f];
     }];
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

-(IBAction)didClickBarButtonHome:(id)sender {
    AppDelegate* delegate = [AppDelegate instance];
    UITabBarController *tabBar = (UITabBarController *)delegate.window.rootViewController;
    [tabBar setSelectedIndex:0];
}


@end

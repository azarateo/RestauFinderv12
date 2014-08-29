//
//  SearchViewController.m
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import "SearchViewController.h"
#import "FavoritesViewController.h"
#import "RestaurantViewController.h"
#import "AppDelegate.h"

#define PICKER_CATEGORIES_TAG 1
#define PICKER_NONE_TAG 0

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize scrollView;

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
    
    
    _searchView = [[MGRawView alloc] initWithNibName:@"SearchView"];
    _searchView.label1.textColor = LIST_TEXT_COLOR;
    _searchView.label2.textColor = LIST_TEXT_COLOR;
    _searchView.label3.textColor = LIST_TEXT_COLOR;
    _searchView.label4.textColor = LIST_TEXT_COLOR;
    
    
    _searchView.ratingViewPrice.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
    _searchView.ratingViewPrice.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
    _searchView.ratingViewPrice.fullSelectedImage = [UIImage imageNamed:@"star_fill.png"];
    _searchView.ratingViewPrice.rating = 1.0;
    _searchView.ratingViewPrice.editable = YES;
    _searchView.ratingViewPrice.maxRating = 5;
    _searchView.ratingViewPrice.midMargin = 0;
    
    _searchView.ratingViewPriceTo.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
    _searchView.ratingViewPriceTo.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
    _searchView.ratingViewPriceTo.fullSelectedImage = [UIImage imageNamed:@"star_fill.png"];
    _searchView.ratingViewPriceTo.rating = 5.0;
    _searchView.ratingViewPriceTo.editable = YES;
    _searchView.ratingViewPriceTo.maxRating = 5;
    _searchView.ratingViewPriceTo.midMargin = 0;
    
//    ratingPrice.delegate = self;
    
    _searchView.ratingViewFood.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
    _searchView.ratingViewFood.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
    _searchView.ratingViewFood.fullSelectedImage = [UIImage imageNamed:@"star_fill.png"];
    _searchView.ratingViewFood.rating = 3.0;
    _searchView.ratingViewFood.editable = YES;
    _searchView.ratingViewFood.maxRating = 5;
    _searchView.ratingViewFood.midMargin = 0;
//    ratingFood.delegate = self;
    
    _searchView.ratingViewFoodTo.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
    _searchView.ratingViewFoodTo.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
    _searchView.ratingViewFoodTo.fullSelectedImage = [UIImage imageNamed:@"star_fill.png"];
    _searchView.ratingViewFoodTo.rating = 5.0;
    _searchView.ratingViewFoodTo.editable = YES;
    _searchView.ratingViewFoodTo.maxRating = 5;
    _searchView.ratingViewFoodTo.midMargin = 0;
    
    _pickerActionSheetCategories = [[UIPickerActionSheet alloc] initForView:self.view];
    _pickerActionSheetCategories.delegate = self;
    _pickerActionSheetCategories.tag = PICKER_CATEGORIES_TAG;
        
    _categoryArray = [CoreDataController getCategoryNames];
    [_categoryArray insertObject:CATEGORY_ALL atIndex:0];
     
    _searchView.textFieldKeywords.delegate = self;
    _searchView.textFieldKeywords.tag = PICKER_NONE_TAG;
    
    _searchView.textFieldCategory.delegate = self;
    _searchView.textFieldCategory.tag = PICKER_CATEGORIES_TAG;
    
    [_searchView.buttonSearch addTarget:self
                                 action:@selector(didClickSearchButton:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:_searchView];
    scrollView.contentSize = _searchView.frame.size;
    scrollView.delaysContentTouches = NO;
}

-(void)pickerActionSheet:(UIPickerActionSheet *)aPickerActionSheet didSelectItem:(id)aItem {
    // User selected aItem
    if(aPickerActionSheet.tag == PICKER_CATEGORIES_TAG)
        _searchView.textFieldCategory.text = aItem;
}

-(void)pickerActionSheetDidCancel:(UIPickerActionSheet *)aPickerActionSheet {
    
}

-(void)pickerActionSheetDidClear:(UIPickerActionSheet *)aPickerActionSheet {
    // user clear
    if(aPickerActionSheet.tag == PICKER_CATEGORIES_TAG)
        _searchView.textFieldCategory.text = @"";
}

-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag != 0)
        [textField resignFirstResponder];
    
    if(textField.tag == PICKER_CATEGORIES_TAG)
        [_pickerActionSheetCategories show:_categoryArray];
}

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField
{
	[theTextField resignFirstResponder];
	return YES;
}

-(void)didClickSearchButton:(id)sender {
    [self beginSearching];
}

-(void)beginSearching {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Searching...";
    
    [self.view addSubview:hud];
	[self.view setUserInteractionEnabled:NO];
    
    NSMutableArray* arrayFilter = [NSMutableArray new];
    __strong typeof(NSMutableArray*) weakFilter = arrayFilter;
    
	[hud showAnimated:YES whileExecutingBlock:^{
        
		[self doSearch:arrayFilter];
        
	} completionBlock:^{
        
		[hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [self performSegueWithIdentifier:@"segueRestaurant" sender:weakFilter];
	}];
    
}



-(void)doSearch:(NSMutableArray*) arrayFilter {
    
    NSString* strKeywords = [[_searchView.textFieldKeywords text] lowercaseString];
    NSString* strCategory = [[_searchView.textFieldCategory text] lowercaseString];
    
    int ratingPrice = [_searchView.ratingViewPrice rating];
    int ratingPriceTo = [_searchView.ratingViewPriceTo rating];
    
    int ratingFood = [_searchView.ratingViewFood rating];
    int ratingFoodTo = [_searchView.ratingViewFoodTo rating];
    
    int countParams = strKeywords.length > 0 ? 1 : 0;
    countParams += strCategory.length > 0 ? 1 : 0;
    countParams += (ratingPrice > 0 && ratingPriceTo > 0) ? 1 : 0;
    countParams += (ratingFood > 0 && ratingFoodTo > 0) ? 1 : 0;
    
    NSArray* arrayRestaurants = [CoreDataController getRestaurants];
    
    
    for(Restaurant* restaurant in arrayRestaurants) {
        
        int qualifyCount = 0;
        
        
        BOOL isFoundKeyword = ([restaurant.name containsString:strKeywords] ||
                               [restaurant.address containsString:strKeywords] ||
                               [restaurant.amenities containsString:strKeywords]);
        
        if( strKeywords.length > 0  && isFoundKeyword)
            qualifyCount += 1;
        
        
        
        if( strCategory.length > 0) {
            Category1* cat = [CoreDataController getCategoryByCategory:strCategory];
            
            BOOL isFoundCat = NO;
            
            if(cat != nil && cat.category_id == restaurant.category_id)
                isFoundCat = YES;
            
            if([strCategory isEqualToString:[CATEGORY_ALL lowercaseString]])
                isFoundCat = YES;
            
            if(isFoundCat)
                qualifyCount += 1;
            
            
        }
        
        BOOL isFoundPrice = (ratingPrice <= [restaurant.price_rating intValue] &&
                             [restaurant.price_rating intValue] <= ratingPriceTo);
        
        if(ratingPrice > 0 && ratingPriceTo > 0 && isFoundPrice)
            qualifyCount += 1;
        
        BOOL isFoundFood = (ratingFood <= [restaurant.price_rating intValue] &&
                            [restaurant.price_rating intValue] <= ratingFoodTo);
        
        if(ratingFood > 0 && ratingFoodTo > 0 && isFoundFood)
            qualifyCount += 1;
        
        
        if(qualifyCount == countParams)
            [arrayFilter addObject:restaurant];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueRestaurant"]) {
        RestaurantViewController* restaurant = (RestaurantViewController*)[segue destinationViewController];
        restaurant.category = nil;
        restaurant.arrayData = (NSMutableArray*)sender;
        
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

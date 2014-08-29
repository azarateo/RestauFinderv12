

#import <UIKit/UIKit.h>
#import "MGTopLeftLabel.h"
#import "RateView.h"

@class MGRawView;

@protocol MGRawViewDelegate <NSObject>

-(void) MGRawView:(MGRawView*)view didPressedAnyButton:(UIButton*)button;

@end

@interface MGRawView : UIView <UITextFieldDelegate> {
    
    __weak id <MGRawViewDelegate> _delegate;
    id _object;
}
@property (nonatomic, retain) id object;

@property (nonatomic, retain) IBOutlet UILabel* labelTitle;
@property (nonatomic, retain) IBOutlet UILabel* labelSubtitle;
@property (nonatomic, retain) IBOutlet UILabel* labelDescription;
@property (nonatomic, retain) IBOutlet UILabel* labelInfo;
@property (nonatomic, retain) IBOutlet UILabel* labelDetails;
@property (nonatomic, retain) IBOutlet UILabel* labelExtraInfo;

@property (nonatomic, weak) __weak id <MGRawViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton* buttonCustom;
@property (nonatomic, retain) IBOutlet UITextField* textFieldCustom;
@property (nonatomic, retain) UITextField* activeTextField;
@property (nonatomic, retain) IBOutlet UIImageView* imgViewThumb;


@property (nonatomic, retain) IBOutlet MGTopLeftLabel* topLeftLabelAddress;
@property (nonatomic, retain) IBOutlet MGTopLeftLabel* topLeftLabelDescription;
@property (nonatomic, retain) IBOutlet MGTopLeftLabel* topLeftLabelAmenities;
@property (nonatomic, retain) IBOutlet UILabel* labelWorkingHours;


@property (nonatomic, retain) IBOutlet RateView* ratingViewPrice;
@property (nonatomic, retain) IBOutlet RateView* ratingViewFood;

@property (nonatomic, retain) IBOutlet RateView* ratingViewFoodTo;
@property (nonatomic, retain) IBOutlet RateView* ratingViewPriceTo;

@property (nonatomic, retain) IBOutlet UITextField* textFieldCategory;
@property (nonatomic, retain) IBOutlet UITextField* textFieldKeywords;

@property (nonatomic, retain) IBOutlet UILabel* label1;
@property (nonatomic, retain) IBOutlet UILabel* label2;
@property (nonatomic, retain) IBOutlet UILabel* label3;
@property (nonatomic, retain) IBOutlet UILabel* label4;
@property (nonatomic, retain) IBOutlet UILabel* label5;

@property (nonatomic, retain) IBOutlet UIButton* buttonSearch;
@property (nonatomic, retain) IBOutlet UIButton* buttonCall;
@property (nonatomic, retain) IBOutlet UIButton* buttonEmail;
@property (nonatomic, retain) IBOutlet UIButton* buttonWeb;
@property (nonatomic, retain) IBOutlet UIButton* buttonShare;
@property (nonatomic, retain) IBOutlet UIButton* buttonFave;


-(id)initWithNibName:(NSString*)nibNameOrNil;

- (id)initWithFrame:(CGRect)frame nibName:(NSString*)nibNameOrNil;

@end


#import <UIKit/UIKit.h>
#import "MGTopLeftLabel.h"

@interface MGListCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel* labelTitle;
@property (nonatomic, retain) IBOutlet UILabel* labelSubtitle;

@property (nonatomic, retain) IBOutlet MGTopLeftLabel* topLeftLabelSubtitle;

@property (nonatomic, retain) IBOutlet UILabel* labelDescription;
@property (nonatomic, retain) IBOutlet UILabel* labelInfo;
@property (nonatomic, retain) IBOutlet UILabel* labelDetails;
@property (nonatomic, retain) IBOutlet UILabel* labelExtraInfo;

@property (nonatomic, retain) IBOutlet UIImageView* imgViewThumb;
@property (nonatomic, retain) IBOutlet UIImageView* imgViewBg;
@property (nonatomic, retain) IBOutlet UIImageView* imgViewPic;
@property (nonatomic, retain) IBOutlet UIImageView* imgViewArrow;
@property (nonatomic, retain) IBOutlet UIImageView* imgViewSelectionBackground;
@property (nonatomic, retain) IBOutlet UIImageView* imgViewFeatured;

@property (nonatomic, retain) UIImage* selectedImage;
@property (nonatomic, retain) UIImage* unselectedImage;

@property (nonatomic, retain) UIImage* selectedImageArrow;
@property (nonatomic, retain) UIImage* unselectedImageArrow;

@property (nonatomic, retain) UIColor* selectedColor;
@property (nonatomic, retain) UIColor* unSelectedColor;

@property (nonatomic, retain) id object;

@end

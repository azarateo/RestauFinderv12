

#import "MGListCell.h"

@implementation MGListCell


@synthesize labelTitle;
@synthesize labelSubtitle;
@synthesize topLeftLabelSubtitle;


@synthesize labelDescription;
@synthesize labelInfo;
@synthesize labelDetails;
@synthesize labelExtraInfo;
@synthesize imgViewThumb;
@synthesize imgViewBg;
@synthesize imgViewPic;


@synthesize selectedImage;
@synthesize unselectedImage;
@synthesize imgViewSelectionBackground;

@synthesize selectedColor;
@synthesize unSelectedColor;
@synthesize imgViewArrow;

@synthesize selectedImageArrow;
@synthesize unselectedImageArrow;

@synthesize object;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    [super setSelected:selected animated:animated];
    
    if(selected) {
        imgViewSelectionBackground.image = selectedImage;
        imgViewArrow.image = selectedImageArrow;
        labelTitle.textColor = selectedColor;
    }
    else {
        imgViewSelectionBackground.image = unselectedImage;
        imgViewArrow.image = unselectedImageArrow;
        labelTitle.textColor = unSelectedColor;
    }
}

@end

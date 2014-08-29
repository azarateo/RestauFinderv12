

#import "MGRawView.h"

@implementation MGRawView

@synthesize object;
@synthesize labelTitle;
@synthesize labelSubtitle;
@synthesize labelDescription;
@synthesize labelInfo;
@synthesize labelDetails;
@synthesize labelExtraInfo;

@synthesize delegate = _delegate;

@synthesize buttonCustom;
@synthesize textFieldCustom;

@synthesize activeTextField;
@synthesize imgViewThumb;

@synthesize topLeftLabelAddress;
@synthesize topLeftLabelAmenities;
@synthesize topLeftLabelDescription;
@synthesize labelWorkingHours;


@synthesize buttonCall;
@synthesize buttonFave;
@synthesize buttonEmail;
@synthesize buttonShare;
@synthesize buttonWeb;

@synthesize ratingViewFoodTo;
@synthesize ratingViewPriceTo;

@synthesize textFieldCategory;
@synthesize textFieldKeywords;

@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;
@synthesize buttonSearch;

-(id)initWithNibName:(NSString*)nibNameOrNil {
    self = [super init];
    
    if (self) {
        // Initialization code
        NSArray* _nibContents = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil
                                                              owner:self
                                                            options:nil];
        self = [_nibContents objectAtIndex:0];
        [self baseInit];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame nibName:(NSString*)nibNameOrNil {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray* _nibContents = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil
                                                              owner:self
                                                            options:nil];
        self = [_nibContents objectAtIndex:0];
        //        self.frame = frame;
        
        [self baseInit];
    }
    
    return self;
}


-(void)baseInit {
    [buttonCustom addTarget:self action:@selector(didClickButtons:) forControlEvents:UIControlEventTouchUpInside];
    textFieldCustom.delegate = self;
}


-(void)didClickButtons:(id)sender {
    [self.delegate MGRawView:self didPressedAnyButton:sender];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView * view in [self subviews]) {
        if (view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}

// dismisses the keyboard when a user selects the return key
- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {
	[theTextField resignFirstResponder];
	return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    activeTextField = textField;
}

@end

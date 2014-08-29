


#import "MGNestedTab.h"

@implementation MGNestedTab

@synthesize numOfButtons = _numOfButtons;
@synthesize titles = _titles;
@synthesize selectedTextColor = _selectedTextColor;
@synthesize normalTextColor = _normalTextColor;
@synthesize delegate = _delegate;
@synthesize buttonFont = _buttonFont;
@synthesize insets = _insets;
@synthesize selectedTabIndex = _selectedTabIndex;

@synthesize arraySelectedImages;
@synthesize arrayUnselectedImages;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self baseInit];
    }
    return self;
}


-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}


-(void) setTitles:(NSArray*)titles {
    _titles = titles;
}


-(void) setButtonInsets:(UIEdgeInsets) insets {
    _insets = insets;
}


-(void) setButtonFont:(UIFont *)buttonFont {
    _buttonFont = buttonFont;
}


-(void) baseInit {
    _numOfButtons = 0;
    _selectedTextColor = [UIColor blackColor];
    _normalTextColor = [UIColor blackColor];
    _titles = [NSArray arrayWithObjects:@"Tab 1", @"Tab 2", @"Tab 3", @"Tab 4", @"Tab 5", nil];
    _buttonFont = [UIFont fontWithName:@"Helvetica" size:14];
}


-(void) layoutSubviews {
    [super layoutSubviews];
}


-(void) setNeedsReLayout {
    for(UIView *view in self.subviews)
        [view removeFromSuperview];
    
    _numOfButtons = _titles.count;
    
    
    if(_numOfButtons > arraySelectedImages.count || _numOfButtons > arrayUnselectedImages.count) {
        @throw [NSException exceptionWithName:@"Mismatch Exception"
                                       reason:@"Mismatch number of buttons, selected image names and unselected image names. It mus be equal."
                                     userInfo:nil];
    }
    
    
    
    float buttonWidth = self.frame.size.width / _numOfButtons;
    for (int x = 0; x < _numOfButtons; x++) {
        CGRect buttonFrame = CGRectMake(x * buttonWidth, 0, buttonWidth, self.frame.size.height);

        UIImage* imageUnselected = [UIImage imageNamed:[arrayUnselectedImages objectAtIndex:x]];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setBackgroundImage:imageUnselected forState:UIControlStateNormal];
        [button setBackgroundImage:imageUnselected forState:UIControlStateSelected];
        [button setBackgroundImage:imageUnselected forState:UIControlStateHighlighted];
        
        
        [button setTitleEdgeInsets:_insets];
        [button setContentMode:UIViewContentModeScaleToFill];
        
        NSString* title = [_titles objectAtIndex:x];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateSelected];
        
        [button setTitleColor:_selectedTextColor forState:UIControlStateSelected];
        [button setTitleColor:_normalTextColor forState:UIControlStateNormal];
        
        [button setFrame:buttonFrame];
        
        if(_buttonFont != nil) {
            [button.titleLabel setFont:_buttonFont];
        }
        
        [button setTag:x];
        [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.delegate MGNestedTab:self didCreateTabButton:button indexTab:x];
        [self addSubview:button];
    }
}


-(void) buttonSelected:(id)sender {
    UIButton* selectedButton = (UIButton*)sender;
    
    for(int x = 0; x < [self.subviews count]; x++) {
        UIButton *button = [self.subviews objectAtIndex:x];
    
        UIImage* imageSelected = [UIImage imageNamed:[arraySelectedImages objectAtIndex:x] ];
        UIImage* imageUnselected = [UIImage imageNamed:[arrayUnselectedImages objectAtIndex:x] ];
        
        if(button.tag == -1)
            continue;
        
        if (button == selectedButton) {
            [button setTitleColor:_selectedTextColor forState:UIControlStateNormal];
            [button setBackgroundImage:imageSelected forState:UIControlStateNormal];
            [button setBackgroundImage:imageSelected forState:UIControlStateSelected];
            [button setBackgroundImage:imageSelected forState:UIControlStateHighlighted];
            
            [self.delegate MGNestedTab:self didSelectTabButton:selectedButton indexTab:(int)selectedButton.tag];
            _selectedTabIndex = (int)selectedButton.tag;
            continue;
        }
        
        [button setTitleColor:_normalTextColor forState:UIControlStateNormal];
        [button setBackgroundImage:imageUnselected forState:UIControlStateNormal];
        [button setBackgroundImage:imageUnselected forState:UIControlStateSelected];
        [button setBackgroundImage:imageUnselected forState:UIControlStateHighlighted];
    }
    
    
}


-(void) setSelectedTab:(int)index {
    for(UIButton *button in self.subviews) {
        if(button.tag > -1 && button.tag == index) {
            [self buttonSelected:button];
        }
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

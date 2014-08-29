


#import <UIKit/UIKit.h>

@class MGNestedTab;

@protocol MGNestedTabDelegate <NSObject>

-(void) MGNestedTab:(MGNestedTab*)nestedTab didSelectTabButton:(UIButton*)button indexTab:(int)index;
-(void) MGNestedTab:(MGNestedTab*)nestedTab didCreateTabButton:(UIButton*)button indexTab:(int)index;

@end

@interface MGNestedTab : UIView{
    
    NSInteger _numOfButtons;
    NSArray* _titles;
    UIColor* _selectedTextColor;
    UIColor* _normalTextColor;
    id <MGNestedTabDelegate> _delegate;
    UIFont* _buttonFont;
    UIEdgeInsets _insets;
    int _selectedTabIndex;
}

@property (nonatomic, assign) NSInteger numOfButtons;
@property (nonatomic, retain) UIColor* selectedTextColor;
@property (nonatomic, retain) UIColor* normalTextColor;
@property (nonatomic, retain) UIFont* buttonFont;
@property (nonatomic, retain) id <MGNestedTabDelegate> delegate;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) int selectedTabIndex;
@property (nonatomic, retain) NSArray* titles;
@property (nonatomic, retain) NSArray* arraySelectedImages;
@property (nonatomic, retain) NSArray* arrayUnselectedImages;

-(void) setTitles:(NSArray*)titles;
-(void) setNeedsReLayout;
-(void) setButtonInsets:(UIEdgeInsets) insets;
-(void) setSelectedTab:(int)index;
-(void) baseInit;

@end

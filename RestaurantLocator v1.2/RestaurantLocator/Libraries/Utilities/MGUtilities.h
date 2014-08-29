


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface MGUtilities : NSObject

+(BOOL)hasInternetConnection;

+(void)showAlertTitle:(NSString*)title message:(NSString*)msg;

+(void)createBorders:(UIImageView*)imgView
         borderColor:(UIColor*)borderColor
         shadowColor:(UIColor*)shadowColor
         borderWidth:(float)borderWidth;

+(void)createBorders:(UIImageView*)imgView
         borderColor:(UIColor*)borderColor
         shadowColor:(UIColor*)shadowColor
         borderWidth:(float)borderWidth
        borderRadius:(CGFloat)radius;

+(BOOL)isRetinaDisplay;

@end

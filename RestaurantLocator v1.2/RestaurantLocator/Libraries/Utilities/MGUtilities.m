


#import "MGUtilities.h"
#import "Reachability.h"


@implementation MGUtilities

+(BOOL)hasInternetConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        return YES;
    }
    
    return NO;
}

+(void)showAlertTitle:(NSString*)title message:(NSString*)msg {
    UIAlertView* alertView;
    
    alertView = [[UIAlertView alloc] initWithTitle:title
                                           message:msg
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    
    [alertView show];
}


+(void)createBorders:(UIImageView*)imgView
         borderColor:(UIColor*)borderColor
         shadowColor:(UIColor*)shadowColor
         borderWidth:(float)borderWidth {
    
    [imgView.layer setShadowOpacity:0.80f];
    [imgView.layer setShadowOffset:CGSizeMake(1.0f, 1.0f)];
    [imgView.layer setShadowColor:[shadowColor CGColor]];
    
    [imgView.layer setBorderWidth:borderWidth];
    [imgView.layer setBorderColor:[borderColor CGColor]];
    
    [imgView.layer setShouldRasterize:YES];
    [imgView.layer setMasksToBounds:YES];
}

+(void)createBorders:(UIImageView*)imgView
         borderColor:(UIColor*)borderColor
         shadowColor:(UIColor*)shadowColor
         borderWidth:(float)borderWidth
        borderRadius:(CGFloat)radius {
    
    [imgView.layer setShadowOpacity:0.80f];
    [imgView.layer setShadowOffset:CGSizeMake(1.0f, 1.0f)];
    [imgView.layer setShadowColor:[shadowColor CGColor]];

    imgView.layer.cornerRadius = radius;
    imgView.clipsToBounds = YES;
    [imgView.layer setBorderWidth:borderWidth];
    [imgView.layer setBorderColor:[borderColor CGColor]];
    
//    [imgView.layer setShouldRasterize:YES];
    [imgView.layer setMasksToBounds:YES];
}

+(BOOL)isRetinaDisplay {
    
    BOOL isRetinaDisplay = NO;
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        isRetinaDisplay = [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
    
    return isRetinaDisplay;
}




@end

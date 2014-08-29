

#import <Foundation/Foundation.h>
#import "TBXMLEx.h"

@interface DataParser : MGParser

+(NSMutableArray*)parseRestaurantFromURLFormatJSON:(NSString*)urlStr;

+(Version*)parseVersionFromURLFormatJSON:(NSString*)urlStr;

+(NSMutableArray*)parseCategoryFromURLFormatJSON:(NSString*)urlStr;

+(NSMutableArray*)parsePhotoFromURLFormatJSON:(NSString*)urlStr;

+(NSMutableArray*)parseDataFromURLFormatJSON:(NSString*)urlStr;

+(NSMutableArray*)parseDataFromURLFormatXML:(NSString*)urlStr;

@end

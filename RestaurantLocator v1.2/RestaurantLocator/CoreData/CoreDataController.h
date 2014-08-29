//
//  CoreDataController.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataController : NSObject

+(NSArray*) getRestaurants;
+(void) deleteAllObjects:(NSString *) entityDescription;
+(Version*) getVersion;
+(NSArray*) getPhotos;
+(NSArray*) getCategories;
+(NSArray*) getRestaurantsByCategoryId:(int)categoryId;
+(NSMutableArray*) getCategoryNames;
+(NSArray*) getFeaturedRestaurants;
+(NSArray*) getPhotosByRestaurantId:(int)restaurantId;
+(Photo*) getPhotoByRestaurantId:(int)restaurantId;

+(NSArray*) getFavoriteRestaurants;
+(Restaurant*) getRestaurantsByRestaurantId:(int)restaurantId;
+(Favorite*) getFavoriteByRestaurantId:(int)restaurantId;
+(Category1*) getCategoryByCategory:(NSString*)category;
@end

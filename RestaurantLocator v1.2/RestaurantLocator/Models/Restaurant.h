//
//  Restaurant.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Restaurant : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * amenities;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * featured;
@property (nonatomic, retain) NSNumber * food_rating;
@property (nonatomic, retain) NSString * hours;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * price_rating;
@property (nonatomic, retain) NSNumber * restaurant_id;
@property (nonatomic, retain) NSNumber * category_id;
@property (nonatomic, retain) NSString * website;

@end

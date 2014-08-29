//
//  Photo.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * photo_id;
@property (nonatomic, retain) NSString * photo_url;
@property (nonatomic, retain) NSNumber * restaurant_id;
@property (nonatomic, retain) NSString * thumb_url;

@end

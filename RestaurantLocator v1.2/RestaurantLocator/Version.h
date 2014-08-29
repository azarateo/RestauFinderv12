//
//  Version.h
//  RestaurantLocator
//
//  
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Version : NSManagedObject

@property (nonatomic, retain) NSNumber * version_id;
@property (nonatomic, retain) NSString * restaurants;
@property (nonatomic, retain) NSString * photos;
@property (nonatomic, retain) NSString * categories;

@end



#import "DataParser.h"
#import "AppDelegate.h"


@implementation DataParser

+(NSMutableArray*)parseRestaurantFromURLFormatJSON:(NSString*)urlStr {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSDictionary* dict = [self getJSONAtURL:urlStr];
    NSMutableArray* array = [NSMutableArray new];
    
    for (NSDictionary* data in dict) {
        
        NSString* className = NSStringFromClass([Restaurant class]);
        NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
        Restaurant* res = (Restaurant*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        
        res.restaurant_id = [NSNumber numberWithInt:[[data objectForKey:@"restaurant_id"] intValue]];
        res.name = [[data objectForKey:@"name"] stringByDecodingXMLEntities];
        res.address = [[data objectForKey:@"address"] stringByDecodingXMLEntities];
        res.lat = [data objectForKey:@"lat"];
        res.lon = [data objectForKey:@"lon"];
        res.desc = [[data objectForKey:@"desc1"] stringByDecodingXMLEntities];
        res.email = [[data objectForKey:@"email"] stringByDecodingXMLEntities];
        res.website = [[data objectForKey:@"website"] stringByDecodingXMLEntities];
        res.amenities = [[data objectForKey:@"amenities"] stringByDecodingXMLEntities];
        res.food_rating = [NSNumber numberWithInt:[[data objectForKey:@"food_rating"] intValue]];
        res.price_rating = [NSNumber numberWithInt:[[data objectForKey:@"price_rating"] intValue]];
        res.featured = [data objectForKey:@"featured"];
        res.phone = [[data objectForKey:@"phone"] stringByDecodingXMLEntities];
        res.hours = [[data objectForKey:@"hours"] stringByDecodingXMLEntities];
        res.created_at = [data objectForKey:@"created_at"];
        res.category_id = [NSNumber numberWithInt:[[data objectForKey:@"category_id"] intValue]];
        
        [array addObject:res];
    }
    
    return array;
}


+(Version*)parseVersionFromURLFormatJSON:(NSString*)urlStr {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSDictionary* dict = [self getJSONAtURL:urlStr];
    
    if(dict != nil) {
        NSString* className = NSStringFromClass([Version class]);
        NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
        Version* res = (Version*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        
        res.version_id = [NSNumber numberWithInt:[[dict objectForKey:@"version_id"] intValue]];
        res.restaurants = [dict objectForKey:@"restaurants"];
        res.photos = [dict objectForKey:@"photos"];
        res.categories = [dict objectForKey:@"categories"];
        
        return res;
    }
    
    return nil;
}


+(NSMutableArray*)parseCategoryFromURLFormatJSON:(NSString*)urlStr {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSDictionary* dict = [self getJSONAtURL:urlStr];
    NSMutableArray* array = [NSMutableArray new];
    
    for (NSDictionary* data in dict) {
        
        NSString* className = NSStringFromClass([Category1 class]);
        NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
        Category1* res = (Category1*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        
        res.category_id = [NSNumber numberWithInt:[[data objectForKey:@"category_id"] intValue]];
        res.category = [[data objectForKey:@"category"] stringByDecodingXMLEntities];
        res.created_at = [data objectForKey:@"created_at"];
        
        [array addObject:res];
    }
    
    return array;
}


+(NSMutableArray*)parsePhotoFromURLFormatJSON:(NSString*)urlStr {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSDictionary* dict = [self getJSONAtURL:urlStr];
    NSMutableArray* array = [NSMutableArray new];
    
    for (NSDictionary* data in dict) {
        
        NSString* className = NSStringFromClass([Photo class]);
        NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
        Photo* res = (Photo*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        res.photo_id = [NSNumber numberWithInt:[[data objectForKey:@"photo_id"] intValue]];
        res.restaurant_id = [NSNumber numberWithInt:[[data objectForKey:@"restaurant_id"] intValue]];
        res.photo_url = [data objectForKey:@"photo_url"];
        res.thumb_url = [data objectForKey:@"thumb_url"];
        res.created_at = [data objectForKey:@"created_at"];
        
        [array addObject:res];
    }
    
    return array;
}

+(NSMutableArray*)parseDataFromURLFormatJSON:(NSString*)urlStr {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSDictionary* dict = [self getJSONAtURL:urlStr];
    NSMutableArray* array = [NSMutableArray new];
    
    NSDictionary* dataDict = [dict valueForKey:@"photos"];
    if(dataDict != nil) {
        for (NSDictionary* photo in dataDict) {
            NSString* className = NSStringFromClass([Photo class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Photo* res = (Photo*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            res.photo_id = [NSNumber numberWithInt:[[photo objectForKey:@"photo_id"] intValue]];
            res.restaurant_id = [NSNumber numberWithInt:[[photo objectForKey:@"restaurant_id"] intValue]];
            res.photo_url = [photo objectForKey:@"photo_url"];
            res.thumb_url = [photo objectForKey:@"thumb_url"];
            res.created_at = [photo objectForKey:@"created_at"];
            
            [array addObject:res];
        }
    }
    
    dataDict = [dict valueForKey:@"restaurants"];
    if(dataDict != nil) {
        
        for (NSDictionary* restDict in dataDict) {
            NSString* className = NSStringFromClass([Restaurant class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Restaurant* res = (Restaurant*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            res.restaurant_id = [NSNumber numberWithInt:[[restDict objectForKey:@"restaurant_id"] intValue]];
            res.name = [[restDict objectForKey:@"name"] stringByDecodingXMLEntities];
            res.address = [[restDict objectForKey:@"address"] stringByDecodingXMLEntities];
            res.lat = [restDict objectForKey:@"lat"];
            res.lon = [restDict objectForKey:@"lon"];
            res.desc = [[restDict objectForKey:@"desc1"] stringByDecodingXMLEntities];
            res.email = [[restDict objectForKey:@"email"] stringByDecodingXMLEntities];
            res.website = [[restDict objectForKey:@"website"] stringByDecodingXMLEntities];
            res.amenities = [[restDict objectForKey:@"amenities"] stringByDecodingXMLEntities];
            res.food_rating = [NSNumber numberWithInt:[[restDict objectForKey:@"food_rating"] intValue]];
            res.price_rating = [NSNumber numberWithInt:[[restDict objectForKey:@"price_rating"] intValue]];
            res.featured = [restDict objectForKey:@"featured"];
            res.phone = [[restDict objectForKey:@"phone"] stringByDecodingXMLEntities];
            res.hours = [[restDict objectForKey:@"hours"] stringByDecodingXMLEntities];
            res.created_at = [restDict objectForKey:@"created_at"];
            res.category_id = [NSNumber numberWithInt:[[restDict objectForKey:@"category_id"] intValue]];
            
            [array addObject:res];
        }
    }
    
    dataDict = [dict valueForKey:@"categories"];
    if(dataDict != nil) {
        
        for (NSDictionary* catDict in dataDict) {
            NSString* className = NSStringFromClass([Category1 class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Category1* res = (Category1*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            res.category_id = [NSNumber numberWithInt:[[catDict objectForKey:@"category_id"] intValue]];
            res.category = [catDict objectForKey:@"category"];
            res.created_at = [catDict objectForKey:@"created_at"];
            
            [array addObject:res];
        }
    }
    
    return array;
}

+(NSMutableArray*)parseDataFromURLFormatXML:(NSString*)urlStr {
    
    TBXMLEx* xml = nil;
    xml = [TBXMLEx parserWithURL:urlStr];
    return [self parseXML:xml];
}

+(NSMutableArray*)parseXML:(TBXMLEx*) xml {
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    if (xml.rootElement) {
        
        // restaurant node
        TBXMLElementEx* node = [xml.rootElement child:@"restaurants"];
        TBXMLElementEx* subNode = [node child:@"item"];
        while ([subNode next]) {
            
            NSString* className = NSStringFromClass([Restaurant class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Restaurant* res = (Restaurant*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            res.restaurant_id = [NSNumber numberWithInt:[[subNode child:@"restaurant_id"] intValue]];
            res.name = [[[subNode child:@"name"] value] stringByDecodingXMLEntities];
            res.address = [[[subNode child:@"address"] value] stringByDecodingXMLEntities];
            res.lat = [[subNode child:@"lat"] value];
            res.lon = [[subNode child:@"lon"] value];
            res.desc = [[[subNode child:@"desc1"] value] stringByDecodingXMLEntities];
            res.email = [[[subNode child:@"email"] value] stringByDecodingXMLEntities];
            res.website = [[[subNode child:@"website"] value] stringByDecodingXMLEntities];
            res.amenities = [[[subNode child:@"amenities"] value] stringByDecodingXMLEntities];
            res.food_rating = [NSNumber numberWithInt:[[subNode child:@"food_rating"] intValue] ];
            res.price_rating = [NSNumber numberWithInt:[[subNode child:@"price_rating"] intValue] ];
            res.featured = [[subNode child:@"featured"] value];
            res.phone = [[[subNode child:@"phone"] value] stringByDecodingXMLEntities];
            res.hours = [[[subNode child:@"hours"] value] stringByDecodingXMLEntities];
            res.created_at = [[subNode child:@"created_at"] value];
            res.category_id = [ NSNumber numberWithInt:[[subNode child:@"category_id"] intValue]];
            
            [array addObject:res];
        }
        
        // categories node
        node = [xml.rootElement child:@"categories"];
        subNode = [node child:@"item"];
        
        while ([subNode next]) {
            
            NSString* className = NSStringFromClass([Category1 class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Category1* cat = (Category1*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            cat.category_id = [NSNumber numberWithInt:[[subNode child:@"category_id"] intValue]];
            cat.category = [[[subNode child:@"category"] value] stringByDecodingXMLEntities];
            cat.created_at = [[subNode child:@"created_at"] value];
            
            [array addObject:cat];
        }
        
        // photos node
        node = [xml.rootElement child:@"photos"];
        subNode = [node child:@"item"];
        
        while ([subNode next]) {
            
            NSString* className = NSStringFromClass([Photo class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Photo* p = (Photo*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            p.photo_id = [NSNumber numberWithInt:[[subNode child:@"photo_id"] intValue]];
            p.restaurant_id = [NSNumber numberWithInt:[[subNode child:@"restaurant_id"] intValue]];
            p.photo_url = [[subNode child:@"photo_url"] value];
            p.thumb_url = [[subNode child:@"thumb_url"] value];
            p.created_at = [[subNode child:@"created_at"] value];
            
            [array addObject:p];
        }
    }
    
    return array;
}


@end

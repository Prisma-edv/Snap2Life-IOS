//
//  GalleryPackage.h
//  snap2life suite
//
//  Created by prisma on 12.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GalleryItem;

@interface GalleryPackage : NSManagedObject

@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSDate * downloadDate;
@property (nonatomic, retain) NSSet *items;

@end

@interface GalleryPackage (CoreDataGeneratedAccessors)

- (void)addItemsObject:(GalleryItem *)value;
- (void)removeItemsObject:(GalleryItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end

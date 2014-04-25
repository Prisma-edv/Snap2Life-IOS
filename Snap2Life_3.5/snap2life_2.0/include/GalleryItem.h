//
//  GalleryItem.h
//  snap2life suite
//
//  Created by prisma on 12.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GalleryItem : NSManagedObject

@property (nonatomic, retain) NSNumber *order;
@property (nonatomic, retain) NSString *packageHref;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSString *detailDescription;
@property (nonatomic, retain) NSString *detailPrice;
@property (nonatomic, retain) NSString *detailPassword;

@end

@interface GalleryItem (CoreDataGeneratedAccessors)

- (void)addImagesObject:(NSManagedObject *)value;
- (void)removeImagesObject:(NSManagedObject *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end

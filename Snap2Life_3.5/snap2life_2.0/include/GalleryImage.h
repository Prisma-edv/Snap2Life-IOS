//
//  GalleryImage.h
//  snap2life suite
//
//  Created by prisma on 12.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GalleryImage : NSManagedObject

@property (nonatomic, retain) NSNumber *order;
@property (nonatomic, copy) NSString *pathToFile;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *link;

@end

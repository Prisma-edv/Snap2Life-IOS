//
//  ARpackage.h
//  snap2life suite
//
//  Created by Antonio Stilo on 30.09.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QCARmodel;

@interface ARpackage : NSManagedObject

@property (nonatomic, retain) NSString * config;
@property (nonatomic, retain) NSString * dat;
@property (nonatomic, retain) NSDate * downloadDate;
@property (nonatomic, retain) NSString * downloadURL;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * memoryFootprint;
@property (nonatomic, retain) NSString * pathToFile;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSSet *models;
@end

@interface ARpackage (CoreDataGeneratedAccessors)

- (void)addModelsObject:(QCARmodel *)value;
- (void)removeModelsObject:(QCARmodel *)value;
- (void)addModels:(NSSet *)values;
- (void)removeModels:(NSSet *)values;

@end

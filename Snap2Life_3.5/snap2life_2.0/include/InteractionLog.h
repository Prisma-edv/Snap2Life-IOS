//
//  InteractionLog.h
//  snap2life suite
//
//  Created by prisma on 21.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InteractionLog : NSManagedObject

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * linkHref;
@property (nonatomic, retain) NSString * gps;
@property (nonatomic, retain) NSString * imageTargetName;
@property (nonatomic, retain) NSString * downloadURL;
@property (nonatomic, retain) NSString * type;

@end

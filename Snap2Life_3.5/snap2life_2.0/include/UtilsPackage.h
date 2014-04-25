//
//  UtilsPackage.h
//  snap2life suite
//
//  Created by Antonio Stilo on 03.06.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UtilsPackage : NSManagedObject

@property (nonatomic, retain) NSString * href;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * order;

@end

//
//  Profile.h
//  snap2life suite
//
//  Created by iOS on 05.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * secretObectID;
@property (nonatomic, retain) NSData * avatar;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSData * secretImage;
@property (nonatomic, retain) NSNumber * skip;

@end

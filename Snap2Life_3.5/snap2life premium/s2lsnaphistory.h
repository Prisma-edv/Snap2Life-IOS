//
//  s2lsnaphistory.h
//  snap2life suite
//
//  Created by Volker Brendel on 23.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface s2lsnaphistory : NSObject

@property (nonatomic, strong) NSString *snapdate;

@property (nonatomic, assign) NSString *name;

- (id)initWithName:(NSString *)snapdate name:(NSString *)name;

@end

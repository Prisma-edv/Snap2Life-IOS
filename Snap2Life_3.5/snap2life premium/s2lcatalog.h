//
//  s2lcatalog.h
//  snap2life suite
//
//  Created by Volker Brendel on 20.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface s2lcatalog : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) NSString *date;

@property (nonatomic, assign) NSString *size;

@property (nonatomic, assign) BOOL active;

@property (nonatomic, assign) NSString *version;

@property (nonatomic, assign) BOOL automatic;

@property (nonatomic, assign) NSString *catalog;

- (id)initWithName:(NSString *)name date:(NSString *)date size:(NSString *)size active:(BOOL)active version:(NSString *)version automatic:(BOOL)automatic catalog:(NSString *)catalog ;

@end

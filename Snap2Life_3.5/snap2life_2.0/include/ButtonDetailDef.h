//
//  ButtonDetail.h
//  snap2life suite
//
//  Created by prisma on 01.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonDetailDef : NSObject

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSString* linkHref;
@property (nonatomic, strong) NSNumber* u;
@property (nonatomic, strong) NSNumber* v;
@property (nonatomic, strong) NSNumber* width;
@property (nonatomic, strong) NSNumber* height;
@property (nonatomic, strong) NSString* imageHref;

@end

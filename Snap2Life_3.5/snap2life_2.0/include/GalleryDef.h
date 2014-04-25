//
//  GalleryDef.h
//  snap2life suite
//
//  Created by prisma on 12.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GalleryDef : NSObject

@property (nonatomic, strong) NSString* version;
@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) NSMutableArray* utils;

@end

//
//  GalleryItemDef.h
//  snap2life suite
//
//  Created by prisma on 12.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GalleryItemDef : NSObject

@property (nonatomic, strong) NSString* packageHref;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic, retain) NSString *detailDescription;
@property (nonatomic, retain) NSString *detailPrice;
@property (nonatomic, retain) NSString *detailPassword;

@end

//
//  Action.h
//  Snap2Life
//
//  Created by prisma on 06.09.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Action : NSObject 

@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* url;
@property int type;

@end

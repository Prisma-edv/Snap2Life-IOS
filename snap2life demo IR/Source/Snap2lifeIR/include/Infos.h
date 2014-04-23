//
//  Infos.h
//  Snap2LifeIR
//
//  Created by Antonio Stilo on 02.09.13.
//  Copyright (c) 2013 Prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Infos : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *extid;
@property (nonatomic, strong) NSString *cat;
@property (nonatomic, strong) NSString *subcat;
@property (nonatomic, strong) NSString *timestamp;
@property BOOL active;
@property (nonatomic, strong) NSString *validStart;
@property (nonatomic, strong) NSString *validEnd;


@end

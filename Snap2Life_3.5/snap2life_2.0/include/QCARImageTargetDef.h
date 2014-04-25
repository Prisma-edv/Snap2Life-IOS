//
//  QCARImageTargetDef.h
//  S2LAR_IOS_1.0
//
//  Created by Antonio Stilo on 23.09.13.
//  Copyright (c) 2013 prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCARImageTargetDef : NSObject

@property (nonatomic,copy) NSString *size;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *model;
@property (nonatomic,copy) NSString *texture;
@property (nonatomic,strong) NSMutableArray *virtualButtons;

@end

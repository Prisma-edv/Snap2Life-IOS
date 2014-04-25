//
//  ModelDef.h
//  Snap2Life
//
//  Created by prisma on 16.07.12.
//  Copyright (c) 2012 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelDef : NSObject

@property (nonatomic, strong) NSString* imageTargetName;
@property (nonatomic, strong) NSString* modelHref;
@property (nonatomic, strong) NSMutableArray* textures;
@property (nonatomic, strong) NSMutableArray* buttonDetails;

/*-- 
 when we have animations, add here also an AnimationDef object
 --*/

@end

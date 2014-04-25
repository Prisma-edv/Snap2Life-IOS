//
//  QCARVirtualButtonDef.h
//  S2LAR_IOS_1.0
//
//  Created by Antonio Stilo on 23.09.13.
//  Copyright (c) 2013 prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture.h"

@interface QCARVirtualButtonDef : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *rectangle;
@property (nonatomic,copy) NSString *enabled;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *texture;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,retain) Texture *qcarTexture;

@end

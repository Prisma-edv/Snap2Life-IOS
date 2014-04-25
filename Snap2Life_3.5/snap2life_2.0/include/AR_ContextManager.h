//
//  AR_ContextManager.h
//  snap2life suite
//
//  Created by iOS on 19.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface AR_ContextManager : NSObject

@property (nonatomic,strong) EAGLContext *context;
@property (nonatomic,copy) NSString *oldPackFile;
@property (nonatomic) int _viewHandle;
@property (nonatomic) int _adHandle;
@property (nonatomic) BOOL isVisarity;
+ (id)sharedInstance;
-(int)create;

@end

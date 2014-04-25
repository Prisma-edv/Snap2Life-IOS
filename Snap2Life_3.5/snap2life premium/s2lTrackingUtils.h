//
//  s2lTrackingUtils.h
//  snap2life suite
//
//  Created by Antonio Stilo on 09.04.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFS2LAppAPIClient.h"
#import "AppDataObject.h"

@interface s2lTrackingUtils : NSObject
{
    BOOL isInteraction;
    NSInteger objID;
}

@property (nonatomic,strong) AppDataObject *ado;
@property (nonatomic, weak) id delegate;

-(void)sendInteractionLog;
-(void)sendVote:(NSString*)value andObjectID:(NSInteger)_objID;
-(void)retriveVote:(NSInteger)_objID;

@end

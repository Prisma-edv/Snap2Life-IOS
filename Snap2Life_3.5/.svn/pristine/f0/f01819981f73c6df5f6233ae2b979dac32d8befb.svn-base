//
//  S2LCommunityManager.h
//  snap2life suite
//
//  Created by iOS on 12.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "S2LCommunitySnapDef.h"

typedef void (^ community_avatar_t) (UIImage *avatar);
typedef void (^ community_snap_t) (UIImage *snap);
typedef void (^ community_comments_t) (NSArray *comments);
typedef void (^ community_snaps_t) (NSArray *snapsDefs);
typedef void (^ community_snapDef_t) (S2LCommunitySnapDef *snapDef);

@interface S2LCommunityManager : NSObject

@property (nonatomic,strong) NSMutableDictionary *avatars;
@property (nonatomic,strong) NSMutableDictionary *snaps;
@property (nonatomic,strong) NSMutableDictionary *comments;

-(void)loadSnapListWithCompletition:(community_snaps_t)completitionBlock;
-(void)loadSnapWithCompletition:(NSString*)snapID completition:(community_snapDef_t)completitionBlock;

-(void)loadAvatar:(NSString*)snapperId withCompletition:(community_avatar_t)completitionBlock;
-(void)loadSnap:(NSString*)snapId withCompletition:(community_snap_t)completitionBlock;
-(void)loadComments:(NSString*)snapId withCompletition:(community_comments_t)completitionBlock;
-(void)flush;

+ (S2LCommunityManager *)sharedInstance;

@end

//
//  S2LCommunityManager.m
//  snap2life suite
//
//  Created by iOS on 12.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LCommunityManager.h"
#import "AFS2LAppAPIClient.h"
#import "PersistenceManager.h"
#import "AppDataObject.h"
#import "S2LIRRequestMaker.h"
#import "S2LSerializerAPI2.h"

@implementation S2LCommunityManager
@synthesize avatars,snaps,comments;


#pragma mark PRIVATE METHODS

#pragma mark PUBLIC METHODS

-(void)flush
{
    comments = nil;
    comments = [[NSMutableDictionary alloc] init];
    
}

-(void)loadSnapWithCompletition:(NSString*)snapID completition:(community_snapDef_t)completitionBlock
{
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];
    
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/modus/rest/api2/interaction/retrieve/GryphosObjectId/%@/SNAP?start=0&count=60", snapID] parameters:nil];
    
    AFKissXMLRequestOperation *operation = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        
        S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
        NSArray *snapsList = [serializer deserializeSnaps:XMLDocument];
        S2LCommunitySnapDef *snapDef = [snapsList objectAtIndex:0];
        completitionBlock(snapDef);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        NSLog(@"SNAP LOADING FAILED %@ %i",request.URL.description,response.statusCode);
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
    
}


-(void)loadSnapListWithCompletition:(community_snaps_t)completitionBlock
{
    // /modus/rest/api2/interaction/retrieve/GryphosObjectId/*/SNAP?start=0&count=20
    
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];
    
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/modus/rest/api2/interaction/retrieve/GryphosObjectId/*/SNAP?start=0&count=60" parameters:nil];
    
    AFKissXMLRequestOperation *operation = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        
        S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
        NSArray *snapsList = [serializer deserializeSnaps:XMLDocument];
        completitionBlock(snapsList);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        NSLog(@"SNAPS LOADING FAILED %@ %i",request.URL.description,response.statusCode);
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];



}

-(void)loadAvatar:(NSString*)snapperId withCompletition:(community_avatar_t)completitionBlock
{
    if ([avatars objectForKey:snapperId] != nil) {
        completitionBlock((UIImage*)[avatars objectForKey:snapperId]);
        return;
    }
    
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];
    
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/modus/rest/api2/hago/overlayimage/%@",snapperId] parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([(NSData*)responseObject length] > 0) {
            UIImage *img = [UIImage imageWithData:responseObject];
            [avatars setObject:img forKey:snapperId];
            
            completitionBlock(img);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"AVATAR LOADING FAILED %@ %@",request.URL.description, [error localizedDescription]);
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
    
}
-(void)loadSnap:(NSString*)snapId withCompletition:(community_snap_t)completitionBlock
{
    if ([snaps objectForKey:snapId] != nil) {
        completitionBlock((UIImage*)[snaps objectForKey:snapId]);
        return;
    }
    
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];
    
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/modus/rest/api2/object/image/%@/-1/-1",snapId] parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([(NSData*)responseObject length] > 0) {
            UIImage *img = [UIImage imageWithData:responseObject];
            [snaps setObject:img forKey:snapId];
            
            completitionBlock(img);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"SNAP LOADING FAILED %@ %@",request.URL.description, [error localizedDescription]);
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
    
}


-(void)loadComments:(NSString*)snapId withCompletition:(community_comments_t)completitionBlock
{
    if ([comments objectForKey:snapId] != nil) {
        completitionBlock((NSArray*)[comments objectForKey:snapId]);
        return;
    }
    
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];
    
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/modus/rest/api2/interaction/retrieve/GryphosObjectId/%@/COMMENT?start=0&count=20",snapId] parameters:nil];
    
    AFKissXMLRequestOperation *operation = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        
        S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
        NSArray *commentsForSnap = [serializer deserializeComments:XMLDocument];
        [comments setObject:commentsForSnap forKey:snapId];
        if(completitionBlock != NULL)completitionBlock(commentsForSnap);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        NSLog(@"COMMENTS LOADING FAILED %@ %i",request.URL.description,response.statusCode);
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
}


#pragma mark INSTANCE INIT


-(id)init
{
    self = [super init];
    if (self) {
        avatars = [[NSMutableDictionary alloc] init];
        snaps = [[NSMutableDictionary alloc] init];
        comments = [[NSMutableDictionary alloc] init];
    }
    
    return self;

}

+ (S2LCommunityManager *)sharedInstance
{
    static S2LCommunityManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[S2LCommunityManager alloc] init];
    });
    return sharedInstance;
}



@end

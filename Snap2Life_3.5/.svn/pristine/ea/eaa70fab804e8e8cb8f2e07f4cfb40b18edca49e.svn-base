//
//  S2LRegister.m
//  snap2life suite
//
//  Created by Robin Kolze on 09/12/13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LRegister.h"
#import "PersistenceManager.h"
#import "S2LSerializerAPI2.h"
#import "ObjectDef.h"
#import "S2LRequestUtils.h"
#import "S2LIRRequestMaker.h"
#import "AppDataObject.h"
#import "Extra.h"
#import "SerializerAPI2.h"

#define kSecret @"community_secret_sc"
#define kAvater @"community_avatar_sc"

@implementation S2LRegister
@synthesize status,compleateBlock,errorBlock;

-(void)checkAvatar:(checkBlock_t)checkBlock
{
    
    status = kRegisterCheck;
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];

    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/modus/rest/api2/hago/overlayimage/%@",[pm.profile.name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"IMG %i",[(NSData*)responseObject length]);
        if ([(NSData*)responseObject length] > 0) {
            UIImage *img = [UIImage imageWithData:responseObject];
            checkBlock(img);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name" message:NSLocalizedString(@"register_alreadyRegistered", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }else{
              [self sendSecret];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"CHECK FAILED %@",request.URL.description);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name" message:NSLocalizedString(@"restore_notCorrect", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
        errorBlock();
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];

}

-(void)sendSecret
{
    status = kRegisterSecret;
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];
    
    
    S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
    ObjectDef *requestObject = [S2LRequestUtils buildSecretObjectForSubcategory:kSecret];
    
    NSString *metadata = [serializer serializeObjectDef:requestObject];
    NSLog(@"METADATA %@",metadata);
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"query/upload/%@",kSecret] parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        [formData appendPartWithFileData:pm.profile.secretImage name:@"image.jpg" fileName:@"image.jpg" mimeType:@"application/octet-stream"];
        [formData appendPartWithFileData:[metadata dataUsingEncoding:NSUTF8StringEncoding] name:kREQUEST_METADATA_KEY fileName:kREQUEST_METADATA_KEY mimeType:@"application/octet-stream"];
        
    }];
    
    
    AFKissXMLRequestOperation *operation = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        
        ObjectDef *secretObject = [serializer deserializeObjectDef:XMLDocument];
        pm.profile.secretObectID = [(Extra*)[secretObject.extras.extra objectAtIndex:0] value];
        [pm saveAll];
        [self sendAvatar];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        NSLog(@"SECRET FAILED %i",response.statusCode);
        errorBlock();
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);}];
    [httpClient enqueueHTTPRequestOperation:operation];
    
}

-(void)sendAvatar
{
    status = kRegisterAvatar;
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];
    
    
    S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
    ObjectDef *requestObject = [S2LRequestUtils buildSecretObjectForSubcategory:kAvater];
    requestObject.infos.title = pm.profile.name;
    requestObject.infos.extid = pm.profile.secretObectID;
    
    NSString *metadata = [serializer serializeObjectDef:requestObject];
    NSLog(@"METADATA %@",metadata);
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"query/upload/%@",kAvater] parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        [formData appendPartWithFileData:pm.profile.avatar name:@"image.jpg" fileName:@"image.jpg" mimeType:@"application/octet-stream"];
        [formData appendPartWithFileData:[metadata dataUsingEncoding:NSUTF8StringEncoding] name:kREQUEST_METADATA_KEY fileName:kREQUEST_METADATA_KEY mimeType:@"application/octet-stream"];
        
    }];
    
    
    AFKissXMLRequestOperation *operation = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        
        [self sendProfile];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        
        NSLog(@"AVATAR FAILED %i",response.statusCode);
        errorBlock();
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);}];
    [httpClient enqueueHTTPRequestOperation:operation];
}

-(void)sendProfile
{
    status = kRegisterProfile;
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];
    SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
    NSString *metadata = [serializer serializeProfile:pm.profile];
    NSLog(@"METADATA %@",metadata);
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/modus/rest/api2/interaction/store" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        [formData appendPartWithFileData:[metadata dataUsingEncoding:NSUTF8StringEncoding] name:@"interaction.xml" fileName:@"interaction.xml" mimeType:@"application/octet-stream"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        status = kRegisterReady;
        compleateBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"PROFILE FAILED %@",request.URL.description);
        errorBlock();
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);}];
    [httpClient enqueueHTTPRequestOperation:operation];

}


+ (S2LRegister *)sharedInstance
{
    static S2LRegister *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[S2LRegister alloc] init];
        sharedInstance.status = kRegisterReady;
    });
    return sharedInstance;
}


@end

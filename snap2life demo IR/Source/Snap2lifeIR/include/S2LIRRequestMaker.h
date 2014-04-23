//
//  Snap2LifeIR.h
//  Snap2LifeIR
//
//  Created by Antonio Stilo on 02.09.13.
//  Copyright (c) 2013 Prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDataObject.h"
#import <UIKit/UIKit.h>
#import "DDXMLDocument.h"
#import "AFKissXMLRequestOperation.h"

NSString const *VERSION = @"1.0";

@interface S2LIRRequestMaker : NSObject

@property (nonatomic,strong) AppDataObject *ado;

-(void) recordForMatch:(UIImage*)snap title:(NSString*)title comment:(NSString*)comment description:(NSString*)desc linksPath:(NSArray*)linksPath
              success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument))success
              failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument))failure;

- (void) evaluateBestMatch:(UIImage*)snap
        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument))success
        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument))failure;


+ (S2LIRRequestMaker *)sharedClient;

@end

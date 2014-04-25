//
//  S2LDownloader.h
//  S2LAR_IOS_1.0
//
//  Created by Antonio Stilo on 20.09.13.
//  Copyright (c) 2013 prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completeBlock_t)(NSString *name, NSString *filePath);
typedef void (^errorBlock_t)(NSError *error);
typedef void (^progressBlock_t)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface S2LDownloader : NSObject

@property (nonatomic,copy)completeBlock_t completeBlock;
@property (nonatomic,copy)errorBlock_t errorBlock;
@property (nonatomic,copy)progressBlock_t progressBlock;

@property (nonatomic,strong) NSString *urlPath;
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) NSString *fileName;


-(void)setCompleteBlocks:(completeBlock_t)complete error:(errorBlock_t)error progress:(progressBlock_t)progress;
-(void)startDownload;
-(void)stopDownload;

@end

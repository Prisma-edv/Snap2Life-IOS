//
//  S2LDownloadPopOverViewController.h
//  snap2life suite
//
//  Created by Antonio Stilo on 30.09.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "S2LDownloaderActionSheet.h"

@class S2LDownloadQueue;

@interface S2LDownloadPopOverViewController : UIViewController <S2LDownloaderActionSheetDelegate>

@property (nonatomic,strong) UIActivityIndicatorView *preloader;
@property (nonatomic,strong) NSObject *package;
@property (nonatomic) NSInteger totalBytes;
@property (nonatomic,readonly) BOOL isSuccess;
@property (nonatomic,strong) S2LDownloadQueue *queue;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UILabel *progressLabel;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) NSArray *downloads;
@property (nonatomic,copy) NSString *currentURLPath;
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic) BOOL startImmediately;
@property (nonatomic,copy)failureBlock_t success;
@property (nonatomic,copy)successBlock_t failure;
@property (nonatomic,copy)abortBlock_t abort;

- (id)initWithURLPath:(NSString*)urlPath automaticStart:(BOOL)start success:(successBlock_t)successBlock abort:(abortBlock_t)abortBlock failure:(failureBlock_t)failureBlock;

@end

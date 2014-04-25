//
//  S2LDownloadQueue.h
//  S2LAR_IOS_1.0
//
//  Created by Antonio Stilo on 20.09.13.
//  Copyright (c) 2013 prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "S2LDownloaderActionSheet.h"

typedef enum {
    kDownloadPreparing,
    kDownloadReady,
    kDownloadDownloading,
    kDownloadFinished
} Status;


@interface S2LDownloadQueue : NSObject

@property (nonatomic,strong) NSArray *downloadPathList;
@property (nonatomic,strong) NSMutableArray *downloaderList;
@property (nonatomic,strong) NSMutableArray *downloadsList;
@property (nonatomic,copy) NSString *directory;
@property (nonatomic) NSInteger totalBytes;
@property (nonatomic) NSInteger totalEffectiveBytes;
@property (nonatomic) NSInteger fileBytes;
@property (nonatomic) NSInteger files;
@property (nonatomic) CGFloat progressValue;
@property (nonatomic) Status status;
@property (nonatomic) id<S2LDownloaderActionSheetDelegate> delegate;


-(id)initWithList:(NSArray*)list andDirectory:(NSString*)currentDirectory andDelegate:(id<S2LDownloaderActionSheetDelegate>)currentDelegate;
-(void)startDownload;
-(void)stopDownload;

@end

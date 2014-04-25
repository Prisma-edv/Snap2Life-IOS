//
//  S2LDownloaderActionSheet.h
//  S2LAR_IOS_1.0
//
//  Created by Antonio Stilo on 20.09.13.
//  Copyright (c) 2013 prisma-edv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class S2LDownloadQueue;

typedef void (^successBlock_t)();
typedef void (^abortBlock_t)();
typedef void (^failureBlock_t)();

@protocol S2LDownloaderActionSheetDelegate <NSObject>

@optional

-(void)ready:(NSInteger)allBytes;
-(void)progress:(CGFloat)percentageBytes;
-(void)error;
-(void)finished:(BOOL)isCompleate;
-(void)cancelHandler;

@end

/*! typical usage
    
    S2LDownloaderActionSheet *downloader = [[S2LDownloaderActionSheet alloc] initWithURLPath:@"link to the xml" automaticStart:YES success:^{
        // do something the data are already stored on the disk and in the database
    } abort:NULL failure:NULL];
 
    example for the XML to download: 
    http://www.snap2life.de/content/ar25/snap2life_gallery_fb_pro.xml
    or 
    http://www.snap2life.de/content/ar25/snap2life/stock/demo_fb.xml
    
 
 */

@interface S2LDownloaderActionSheet : UIActionSheet <S2LDownloaderActionSheetDelegate,UIActionSheetDelegate>

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
@property (nonatomic,copy)abortBlock_t abort;
@property (nonatomic,copy)successBlock_t failure;

- (id)initWithURLPath:(NSString*)urlPath automaticStart:(BOOL)start success:(successBlock_t)successBlock abort:(abortBlock_t)abortBlock failure:(failureBlock_t)failureBlock;

@end

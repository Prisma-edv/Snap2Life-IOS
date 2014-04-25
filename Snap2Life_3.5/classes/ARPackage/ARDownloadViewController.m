//
//  ARDownloadViewController.m
//  Snap2Life
//
//  Created by prisma on 08.10.12.
//  Copyright (c) 2012 Prisma Gmbh. All rights reserved.
//

#import "Constants.h"

#import "ARDownloadViewController.h"
#import "ARPackageDef.h"
#import "ModelDef.h"
#import "TextureDef.h"
#import "ARPackageLoader.h"

@interface ARDownloadViewController ()

// Properties which will be displayed in the Action Sheet in addition to the Cancel and (optional) Download buttons.
@property (nonatomic,retain) UILabel* descLbl_;
@property (nonatomic,retain) UIProgressView* progressView_;
@property (nonatomic,retain) UILabel* progressLbl_;

// The remote AR package XML.
@property (nonatomic,copy) NSString* arPackageXml_;

// The remote URL string, local directory for download, temp directory.
@property (nonatomic,copy) NSString* fromURL_;
@property (nonatomic,copy) NSString* toDir_;
@property (nonatomic,copy) NSString* tempDir_;

// The blocks to be run at successful or aborted completion.
@property (nonatomic,copy) voidBlock_t successBlock_;
@property (nonatomic,copy) voidBlock_t failureBlock_;

// A list of all open connections with their file names.
@property (nonatomic,retain) NSMutableDictionary* connections_;

// Total download size, discovered at initialization (== NSNotFound if errors in remote connections).
@property (nonatomic,assign) NSUInteger totalSize_;

// Mutex to force the loadPackage method to run exclusively.
@property (nonatomic,retain) NSLock* runningLock_;

// Method to update the progress bar and progress label with a new size.
- (void)updateProgressWithSize:(NSUInteger)size ofTotal:(NSUInteger)totalSize;

// Method to update the descLbl, for instance in the case of a connection error.
- (void)updateDescLbl:(NSString*)desc isError:(BOOL)isError;

// Iterates through all downloadable URLs in the AR package, storing unique URLs in an array.
- (NSArray*)extractUniqueDownloadURLsFromPackage;

// Gets the total size of files at the URLs in the array by sending HTTP HEAD requests to the fromURL_.
- (NSUInteger)downloadSizeAtURLs:(NSArray*)downloadURLs;

// Downloads the AR package to the toDir_ and dismisses the action sheet.
// Stays in the action sheet if an error message is displayed. 
- (BOOL)loadPackage;

// Iterates through all downloadable URLs in the list, storing in the temp directory. Returns no.of bytes downloaded.
- (NSUInteger)downloadInLoop:(NSArray*)downloadURLs;

// Clenaup routine called when the ActionSheet is dismissed. We do this because we are not sure when dealloc is called.
- (void)cleanup;

@end

@implementation ARDownloadViewController

@synthesize success;

@synthesize descLbl_;
@synthesize progressView_;
@synthesize progressLbl_;
@synthesize arPackageXml_;
@synthesize fromURL_;
@synthesize toDir_;
@synthesize tempDir_;
@synthesize successBlock_;
@synthesize failureBlock_;
@synthesize connections_;
@synthesize totalSize_;
@synthesize runningLock_;

- (id)initForPackage:(NSString*)arPackageXml withTitle:(NSString*)title fromURL:(NSString*)fromURL toDir:(NSString*)toDir tempDir:(NSString*)tempDir
  startImmediately:(BOOL)startImmediately  onSuccess:(voidBlock_t)successBlock onFailure:(voidBlock_t)failureBlock
{
    // Set up a UIActionSheet with just a Cancel button if already downloading when started,
    // or with a Cancel and a Download button.
    if ((self = [super initWithTitle:nil delegate:nil cancelButtonTitle:nil
              destructiveButtonTitle:NSLocalizedString(@"button_cancel", nil)
                   otherButtonTitles:nil]) != nil) {
        // Custom initialization for the parent UIActionSheet.
        [self setTitle:title];
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [self setDelegate:self];
        if (!startImmediately) [self addButtonWithTitle:NSLocalizedString(@"button_update", nil)];
        
        // Initialize the other properties.
        arPackageXml_ = [arPackageXml copy];
        fromURL_ = [fromURL copy];
        toDir_ = [toDir copy];
        tempDir_ = [tempDir copy];
        successBlock_ = [successBlock copy];
        failureBlock_ = [failureBlock copy];
        connections_ = [[NSMutableDictionary alloc] init];
        runningLock_ = [[NSLock alloc] init];
        
        // Display the action sheet against the background so as to generate its frame dimensions.
        [self showInView:[[[UIApplication sharedApplication] delegate] window]];
        
        // Make space for and add a description label, a progress bar and a progress label under the button(s).
        float btnHeight = (startImmediately)? 0: 30.0f;
        float offset = 90.0f + btnHeight;
        CGRect frame = [self frame];
        frame.origin.y -= offset;
        frame.size.height += offset;
        [self setFrame:frame];
        if (DEBUG_VERBOSE) NSLog(@"ARDownloadViewController frame: (%f,%f,%f,%f)", [self frame].origin.x, [self frame].origin.y, [self frame].size.width, [self frame].size.height);

        descLbl_ = [[UILabel alloc] initWithFrame:CGRectMake(24.0f, offset+btnHeight+0.0f, 272.0f, 48.0f)];
        [descLbl_ setLineBreakMode:NSLineBreakByWordWrapping];
        [descLbl_ setNumberOfLines:0];
        [descLbl_ setFont:[UIFont systemFontOfSize:11.0f]];
        [descLbl_ setTextColor:[UIColor whiteColor]];
        [descLbl_ setBackgroundColor:[UIColor clearColor]];
        [descLbl_ setText:NSLocalizedString(@"ar_download_text", nil)];
        [self addSubview:descLbl_];
        
        progressView_ = [[UIProgressView alloc] initWithFrame:CGRectMake(24.0f, offset+btnHeight+50.0f, 272.0f, 9.0f)];
        [self addSubview:progressView_];
        
        progressLbl_ = [[UILabel alloc] initWithFrame:CGRectMake(24.0f, offset+btnHeight+65.0f, 272.0f, 21.0f)];
        [progressLbl_ setFont:[UIFont systemFontOfSize:11.0f]];
        [progressLbl_ setTextColor:[UIColor whiteColor]];
        [progressLbl_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:progressLbl_];
        [self updateProgressWithSize:0 ofTotal:1]; // dummy totalSize_ to set progressView initially.
        
        // Start long term queries asynchronously.
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Get the totalSize_ by HTTP HEAD requests (or NSNotFound if network error).
            totalSize_ = [self downloadSizeAtURLs:[self extractUniqueDownloadURLsFromPackage]];
            if (totalSize_ == NSNotFound) totalSize_ = 0;
            dispatch_sync( dispatch_get_main_queue(), ^{
                [self updateProgressWithSize:0 ofTotal:totalSize_];
            });
            
            // Start downloading if it should commence immediately and when complete, cancel the action sheet.
            if (startImmediately) {
                if ([self loadPackage]) {
                    dispatch_sync( dispatch_get_main_queue(), ^{
                        [self dismissWithClickedButtonIndex:[self destructiveButtonIndex] animated:YES];
                    });
                }
            }
        });
    }
    return self;
}

// Clenaup routine called whe the ActionSheet is dismissed. We do this because we are not sure when dealloc is called.
- (void)cleanup
{
    [descLbl_ release];
    descLbl_ = nil;
    [progressView_ release];
    progressView_ = nil;
    [progressLbl_ release];
    progressLbl_ = nil;
    [arPackageXml_ release];
    arPackageXml_ = nil;
    [fromURL_ release];
    fromURL_ = nil;
    [toDir_ release];
    toDir_ = nil;
    [tempDir_ release];
    tempDir_ = nil;
    [successBlock_ release];
    successBlock_ = nil;
    [failureBlock_ release];
    failureBlock_ = nil;
    [connections_ release];
    connections_ = nil;
    [runningLock_ release];
    runningLock_ = nil;
}

- (void)dealloc
{
    if (DEBUG_VERBOSE) NSLog(@"ARDownloadViewController dealloc");
    [self cleanup];
	[super dealloc];
}

#pragma mark - UIActionSheetDelegate protocol implementations

// Sent to the delegate when the user clicks a button on an action sheet.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (DEBUG_VERBOSE) NSLog(@"ARDownloadViewController calling actionSheet:clickedButtonAtIndex:%d", buttonIndex);
    // Check if the Cancel or the Download button has been pressed.
    if (buttonIndex == [self destructiveButtonIndex]) {
        // If the download loop is running, cancel it by pulling away the connections under its feet.
        if ([runningLock_ tryLock]) {
            [runningLock_ unlock];
        }
        else {
            @synchronized (connections_) {
                for (AsyncURLDownload* connection in [connections_ allValues]) {
                    [connection cancel];
                }
                [connections_ removeAllObjects];
            }
        }
    }
    else {
        // Download button pressed, so start the download and when complete, cancel the action sheet.
        if ([self loadPackage]) {
            [self dismissWithClickedButtonIndex:[self destructiveButtonIndex] animated:YES];
        }
    }
}

#pragma mark - UIActionSheet method implementations

// Dismisses the action sheet immediately using an optional animation.
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (DEBUG_VERBOSE) NSLog(@"ARDownloadViewController calling dismissWithClickedButtonIndex:%d", buttonIndex);
    // According to the docs, the action sheet calls this method itself in response to the user
    // tapping one of the buttons in the action sheet. So here all actions but the Cancel
    // action are captured and prevented from causing the ActionSheet to dismiss.
    if (buttonIndex == [self destructiveButtonIndex]) {
        // Call the success or failure blocks appropriately and cleanup the object.
        if (failureBlock_) failureBlock_();
        else if (successBlock_) successBlock_();
        [self cleanup];
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
}

#pragma mark - Custom methods

// Method to update the progress bar and progress label with a new size.
- (void)updateProgressWithSize:(NSUInteger)size ofTotal:(NSUInteger)totalSize {
    float fraction = (totalSize > 0)? ((float)size) / totalSize: 0.0f;
    [progressView_ setProgress:fraction];
    NSString* formatString = NSLocalizedString(@"ar_download_progress", nil); //"%d%% von %0.2f MB"
    [progressLbl_ setText:[NSString stringWithFormat:formatString, (int)(fraction*100), totalSize/(1024 * 1024.0f)]];
}

// Method to update the descLbl, for instance in the case of a connection error.
- (void)updateDescLbl:(NSString*)desc isError:(BOOL)isError {
    [descLbl_ setText:desc];
    if (isError) {
        // Set to red if error.
        [descLbl_ setTextColor:UIColorFromRGB(0xFF0000,1)];
    }
}

// Iterates through all downloadable URLs in the AR package, storing unique URLs in an array.
- (NSArray*)extractUniqueDownloadURLsFromPackage {
    // Deserialize the arPackageXml_ to a ARPackageDef.
    ARPackageDef* arPackageDef = [ARPackageLoader arPackageDefFromXmlString:arPackageXml_];
    NSMutableSet* downloadURLs = [NSMutableSet set];
    [downloadURLs addObject:[[arPackageDef trackable] configHref]];
    [downloadURLs addObject:[[arPackageDef trackable] datHref]];
    for (ModelDef* model in [[arPackageDef trackable] models]) {
        [downloadURLs addObject:[model modelHref]];
        for (TextureDef* texture in [model textures]) {
            [downloadURLs addObject:[texture textureHref]];
        }
    }
    return [downloadURLs allObjects];
}

// Gets the total size of files at the URLs in the array by sending HTTP HEAD requests.
- (NSUInteger)downloadSizeAtURLs:(NSArray*)downloadURLs {
    NSUInteger total = 0;
    for (NSString* fileURL in downloadURLs) {
        NSInteger fileSize = [AsyncURLDownload downloadSizeAtUrl:[fromURL_ stringByAppendingPathComponent:fileURL] withTimeout:AR_TIMEOUT];
        if (fileSize != NSNotFound) total += fileSize;
        else {
            total = NSNotFound;
            break;
        }
    }
    return total;
}

// Downloads the AR package to the toDir_ and dismisses the action sheet.
// Stays in the action sheet if an error message is displayed.
- (BOOL)loadPackage {
    // Try to acquire the mutex to prevent the download button being activated more than once.
    if (![runningLock_ tryLock]) return NO;
    
    // Empty the temp directory.
    for (NSString* fileName in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tempDir_ error:NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:[tempDir_ stringByAppendingPathComponent:fileName] error:NULL];
    }
    
    // Iterate through all downloadable URLs in the package, storing in an array.
    NSArray* downloadURLs = [self extractUniqueDownloadURLsFromPackage];

    // Iterates through all downloadable URLs in the list, storing in the temp directory. Returns no.of bytes downloaded.
    NSUInteger downloadSize = [self downloadInLoop:downloadURLs];
    
    BOOL successful = (downloadSize == totalSize_);
    if (successful) {
        // Write the package itself to the temp directory.
        NSError* error = nil;
        [arPackageXml_ writeToFile:[tempDir_ stringByAppendingPathComponent:AR_PACKAGE_XML]
                        atomically:NO
                          encoding:NSUTF8StringEncoding
                             error:&error];
        if (!error) {
            // Empty the destination directory.
            for (NSString* fileName in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:toDir_ error:&error]) {
                [[NSFileManager defaultManager] removeItemAtPath:[toDir_ stringByAppendingPathComponent:fileName] error:&error];
            }
        }
        if (!error) {
            // Move all the downloadables to the destination directory.
            for (NSString* fileName in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tempDir_ error:&error]) {
                [[NSFileManager defaultManager] moveItemAtPath:[tempDir_ stringByAppendingPathComponent:fileName] toPath:[toDir_ stringByAppendingPathComponent:fileName] error:&error];
            }
        }
        if (error) {
            // If error in writing, log the error.
            NSLog(@"ARDownloadViewController ERROR %@:%d writing to file system: %@",
                  [error domain],
                  [error code],
                  [error localizedDescription]);
            // And inform of an error.
            dispatch_async( dispatch_get_main_queue(), ^{
                [self updateDescLbl:NSLocalizedString(@"ar_download_failed", nil) isError:YES];
            });
            successful = NO;
        }
    }

    if (successful) {
        // Download was successful, so we don't need a failureBlock_, thus forcing the successBlock_.
        [self setFailureBlock_:nil];
    }
    
    // Free the mutex.
    [runningLock_ unlock];
    return successful;
}

// Iterates through all downloadable URLs in the list, storing in the temp directory. Returns no.of bytes downloaded.
- (NSUInteger)downloadInLoop:(NSArray*)downloadURLs {
    // Set up a synchronizable number for the downloaded size and an NSError object as a one-member array of NSNumber.
    NSMutableArray* runningSize = [NSMutableArray arrayWithObject:[NSNumber numberWithUnsignedInteger:0]];
    NSMutableArray* runningError = [NSMutableArray arrayWithObject:[NSNull null]];

    for (NSString* fileURL in downloadURLs) {
        AsyncURLDownload* connection = [[AsyncURLDownload alloc]
                                        initWithRequest:[fromURL_ stringByAppendingPathComponent:fileURL]
                                        timeout:AR_TIMEOUT
                                        forFilePath:[tempDir_ stringByAppendingPathComponent:fileURL]
                                        onCompletion:^{
                                            // Remove the connection from the map.
                                            @synchronized (connections_) {
                                                [connections_ removeObjectForKey:fileURL];
                                            }
                                            if (DEBUG_VERBOSE) NSLog(@"ARDownloadViewController completed downloading %@", [fromURL_ stringByAppendingPathComponent:fileURL]);
                                        }
                                        onError:^(NSError *error) {
                                            // Capture the error because the handling of it will be on a different thread.
                                            @synchronized (runningError) {
                                                if (![[runningError objectAtIndex:0] isKindOfClass:[NSError class]]) {
                                                    [runningError replaceObjectAtIndex:0 withObject:error];
                                                }
                                            }
                                        }
                                        onAppend:^(NSUInteger appendSize) {
                                            // Increment the running size by the new append size and inform the progress view on the main thread.
                                            NSUInteger size;
                                            @synchronized (runningSize) {
                                                size = [[runningSize objectAtIndex:0] unsignedIntegerValue] + appendSize;
                                                [runningSize replaceObjectAtIndex:0 withObject:[NSNumber numberWithUnsignedInteger:size]];
                                            }
                                            if (DEBUG_TIMES) NSLog(@"ARDownloadViewController receiving %0.2fkB of %0.2fMB from %@", appendSize/1024.0f, totalSize_/(1024*1024.0f), fileURL);
                                            dispatch_async( dispatch_get_main_queue(), ^{
                                                [self updateProgressWithSize:size ofTotal:totalSize_];
                                            });
                                        }];
        @synchronized (connections_) {
            if ([connections_ objectForKey:fileURL] != nil) {
                NSLog(@"ARDownloadViewController duplicate content filling connection container with fileURL %@", fileURL);
            }
            [connections_ setObject:connection forKey:fileURL];
        }
        // Release the connection which is now in the connections_ container.
        [connection release];
    }

    for (;;) {
        // Get the first connection in the container.
        NSString* fileURL = nil;
        AsyncURLDownload* connection = nil;
        @synchronized (connections_) {
            if ([connections_ count] > 0) {
                fileURL = [[[connections_ allKeys] objectAtIndex:0] retain];
                connection = [[connections_ objectForKey:fileURL] retain];
            }
        }
        if (connection == nil) break;

        // Start the connection and wait in a loop till the synchronous thread finishes.
        [connection start];
        BOOL finished = NO;
        while (!finished) {
            // Wait for a fraction of a second on the current runloop.
            // Note that [NSThread sleepForTimeInterval:] could not be used because the
            // NSURLConnection class uses callbacks which are examined in the runloop
            // and a sleep prevents the runloop from being reached.
            if (DEBUG_TIMES) NSLog(@"ARDownloadViewController getting run loop events for %0.3fs", AR_TIMEOUT/10.0);
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:AR_TIMEOUT/10.0]];
            
            @synchronized (runningError) {
                // Check if the runningError contains an error, log it and leave the loop.
                if ([[runningError objectAtIndex:0] isKindOfClass:[NSError class]]) {
                    NSError* error = (NSError*)[runningError objectAtIndex:0];
                    NSLog(@"ARDownloadViewController connection error %@:%d downloading URL %@: %@",
                          [error domain],
                          [error code],
                          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey],
                          [error localizedDescription]);
                    // Stop all the connections.
                    @synchronized (connections_) {
                        for (AsyncURLDownload* connection in [connections_ allValues]) {
                            [connection cancel];
                        }
                        [connections_ removeAllObjects];
                    }
                    // And inform of an error.
                    dispatch_async( dispatch_get_main_queue(), ^{
                        [self updateDescLbl:NSLocalizedString(@"ar_download_failed", nil) isError:YES];
                    });
                    break;
                }
            }
            
            @synchronized (connections_) {
                // Loop finishes when the connection has finished and been removed from the container.
                if ([connections_ objectForKey:fileURL] == nil) finished = YES;
            }
        }
        [connection release];
        [fileURL release];
    }

    // Return no.of bytes downloaded.
    return [[runningSize objectAtIndex:0] unsignedIntegerValue];
}

@end

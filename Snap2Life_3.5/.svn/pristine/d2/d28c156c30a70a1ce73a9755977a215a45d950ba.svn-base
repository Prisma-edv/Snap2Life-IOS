//
//  S2LProtocols.h
//  snap2life suite
//
//  Created by Antonio Stilo on 30.09.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"
#import "History.h"

@protocol CaptureSessionManagerDelegate
- (void) didCapturedStillImage:(UIImage*) image;
@end

@protocol SettingsDelegate
- (void) settingsChanged;
@end

@protocol OverlayControlsViewControllerDelegate
- (void)takePicture;
- (void)startCaptureSession;
- (void)stopCaptureSession;
- (void)cancelRequestQueue;
- (void)putNewImageWithTitle:(NSString*)title withLinkName:(NSString *)linkName withUrl:(NSString *)linkUrl;
@end

@protocol WebViewDelegate <NSObject>

-(void)setCurrentHistory:(History*)history;
-(void)openWebUrlAndStore:(NSString*)urlString andTargetName:(NSString*)name;
-(void)resendImageForRecognition:(History*)history;

@end

@protocol DBDelegate
- (void)saveSettings;
- (NSMutableArray*)allHistories;
- (History*)createHistory;
- (Settings*)getAppSettings;
- (BOOL)removeHistoryItem:(NSInteger)index;
@end

@protocol UIViewDelegate <NSObject>

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@protocol MyOverlayViewDelegate
- (void)handleTwoFingersSnap;
@end


@protocol ResultViewControllerDelegate <NSObject>

@optional
-(void)setCurrentHistory:(History*)history;
-(void)changeScreen:(NSObject*)obj;

@end
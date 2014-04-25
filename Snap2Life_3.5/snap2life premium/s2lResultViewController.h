//
//  s2lResultViewController.h
//  snap2life suite
//
//  Created by Antonio Stilo on 18.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "History.h"
#import "s2lErrorSubview.h"
#import "s2lResultView.h"
#import "AppDataObject.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "s2lSnapWebViewController.h"
#import "S2LIRRequestMaker.h"
#import "S2LProtocols.h"

@interface s2lResultViewController : UIViewController <WebViewDelegate,ResultViewControllerDelegate>
{
    IBOutlet s2lErrorSubview *_errorView;
    IBOutlet s2lResultView *_resultView;
    
    SLComposeViewController *mySLComposerSheet;
    s2lSnapWebViewController *webViewController;
    
    BOOL isFirst;
    
}

@property (nonatomic,strong) History *currentHistory;

-(IBAction)doneButtonPressed:(id)sender;

- (BOOL) requestFinishedCounterZero;
-(void)shearOnFaceBook:(UIImage*)snap;
-(void)shearOnTweeter:(UIImage*)snap;

-(void)resendImageForRecognition:(History*)history;

@end

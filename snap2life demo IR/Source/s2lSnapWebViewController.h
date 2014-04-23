//
//  s2lSnapWebViewController.h
//  snap2life suite
//
//  Created by Volker Brendel on 24.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface s2lSnapWebViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *s2lwebview;
    NSString *_urlString;
    BOOL isExternal;
    IBOutlet UIBarButtonItem *back;
}
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayer;
@property (nonatomic,strong) NSString *urlString;

-(IBAction)goBack:(id)sender;
-(IBAction)goFoward:(id)sender;

- (IBAction)cancelButtonPressed:(id)sender;

- (IBAction)doneButtonPressed:(id)sender;
-(IBAction)goBack:(id)sender;

@end

//
//  S2LNavigationUtils.m
//  snap2life suite
//
//  Created by iOS on 22.11.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LNavigationUtils.h"
#import "s2lSnapWebViewController.h"
#import "AVCamAppDelegate.h"

@implementation S2LNavigationUtils


+(void)openWebUrlAndStore:(NSString*)urlString andTargetName:(NSString*)name fromViewController:(UIViewController*)controller
{
    [S2LNavigationUtils openWebUrl:urlString fromViewController:controller];
}

+(void)openWebUrl:(NSString *)urlString fromViewController:(UIViewController*)controller
{
        UIStoryboard *storyboard = controller.storyboard;
        s2lSnapWebViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"web"];
        AVCamAppDelegate *appDelegate = (AVCamAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.urlToOpen = urlString;
        [controller presentViewController:webViewController animated:YES completion:nil];
    
}


@end

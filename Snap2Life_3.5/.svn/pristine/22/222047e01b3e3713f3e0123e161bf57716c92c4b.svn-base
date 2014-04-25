//
//  S2LNavigationUtils.m
//  snap2life suite
//
//  Created by iOS on 22.11.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LNavigationUtils.h"
#import "PersistenceManager.h"
#import "s2lSnapWebViewController.h"
#import "s2lAppDelegate.h"

@implementation S2LNavigationUtils

+(void)shearOnTweeter:(UIImage*)snap fromViewController:(UIViewController*)controller
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Snap2Life: "];
        [tweetSheet addImage:snap];
        [controller presentViewController:tweetSheet animated:YES completion:nil];
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successfull";
                    break;
                default:
                    break;
            } //check if everythink worked properly. Give out a message on the state.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweeter" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweeter" message:@"You don´t have a Tweeter account installed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
    
}

+(void)shearOnFaceBook:(UIImage*)snap fromViewController:(UIViewController*)controller
{
    //if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    //{
    SLComposeViewController* mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
    mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
    [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Snap2Life: "]]; //the message you want to post
    [mySLComposerSheet addImage:snap]; //an image you could post
    //for more instance methodes, go here:https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Reference/SLComposeViewController_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40012205
    [controller presentViewController:mySLComposerSheet animated:YES completion:nil];
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everythink worked properly. Give out a message on the state.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
    /*}else{
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"You don´t have a Facebook account installed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [alert show];
     }*/
}

+(void)openWebUrlAndStore:(NSString*)urlString andTargetName:(NSString*)name fromViewController:(UIViewController*)controller
{
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    [pm interactionLogItemWithLink:urlString withTargetName:name andType:@"LINKED"];
    [S2LNavigationUtils openWebUrl:urlString fromViewController:controller];
}

+(void)openWebUrl:(NSString *)urlString fromViewController:(UIViewController*)controller
{
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    Settings *settings = [pm settings];
    
    if(![[settings settingBrowser] boolValue]){
        UIStoryboard *storyboard = controller.storyboard;
        s2lSnapWebViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"web"];
        s2lAppDelegate *appDelegate = (s2lAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.urlToOpen = urlString;
        [controller presentViewController:webViewController animated:YES completion:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    
}


@end

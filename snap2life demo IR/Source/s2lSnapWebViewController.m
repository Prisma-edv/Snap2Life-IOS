//
//  s2lSnapWebViewController.m
//  snap2life suite
//
//  Created by Volker Brendel on 24.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lSnapWebViewController.h"
#import "AVCamAppDelegate.h"

@interface s2lSnapWebViewController ()

@end

@implementation s2lSnapWebViewController
@synthesize urlString = _urlString;
@synthesize moviePlayer;

-(IBAction)goBack:(id)sender
{
    if (s2lwebview.canGoBack) {
         [s2lwebview goBack];
    }else{
        if(![_urlString isEqualToString:@""])[s2lwebview loadHTMLString:_urlString baseURL:nil];
    }
   
}

-(IBAction)goFoward:(id)sender
{
    [s2lwebview goForward];
}
-(void)viewDidLayoutSubviews
{
    if (moviePlayer != nil && !moviePlayer.moviePlayer.fullscreen) {
        
        if (!isIPad) {
            if ([UIScreen mainScreen].bounds.size.height >= 568.0) {
                // iPhone 5
                if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                    moviePlayer.moviePlayer.view.frame = CGRectMake(0, 0, 320, 461 );
                }else{
                    moviePlayer.moviePlayer.view.frame = CGRectMake(0, 0, 568, 220 );
                }
            }
            else {
                if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                    moviePlayer.moviePlayer.view.frame = CGRectMake(0, 0, 320, 373 );
                }else{
                    moviePlayer.moviePlayer.view.frame = CGRectMake(0, 0, 480, 220 );
                }
            }
        }else{
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                moviePlayer.moviePlayer.view.frame = CGRectMake(0, 0, 768, 800 );
            }else{
                moviePlayer.moviePlayer.view.frame = CGRectMake(0, 0, 1024, 700 );
            }
        }
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _urlString = @"";
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(isExternal)[self dismissViewControllerAnimated:NO completion:NULL];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(BOOL) shouldAutorotate {
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

-(void) youTubeStarted:(NSNotification*) notif {
    AVCamAppDelegate *appDelegate = (AVCamAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.fullScreenVideoIsPlaying = YES;
}
-(void) youTubeFinished:(NSNotification*) notif {
    AVCamAppDelegate *appDelegate = (AVCamAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.fullScreenVideoIsPlaying = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AVCamAppDelegate *appDelegate = (AVCamAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = [UIColor blackColor];
    self.navigationController.toolbarHidden = NO;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor blackColor];
    
    back.title = NSLocalizedString(@"back_btn", nil);
    
    if ([appDelegate.urlToOpen isEqualToString:@""] || appDelegate.urlToOpen == nil) {
        appDelegate.urlToOpen = @"http://mobile.editionhoch3.de/";
    }
    
    UIActivityIndicatorView *preloader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [preloader startAnimating];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:preloader];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerWillExitFullscreenNotification" object:nil];
   
    if([appDelegate.urlToOpen hasPrefix:@"http://"] || [appDelegate.urlToOpen hasPrefix:@"tel://"]){
        isExternal = NO;
         NSLog(@"** Web View %@",appDelegate.urlToOpen);
        NSURL *s2lurl = [NSURL URLWithString:appDelegate.urlToOpen];
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:s2lurl];
        [s2lwebview loadRequest:myRequest];
    }else if ([appDelegate.urlToOpen rangeOfString:@"<html"].location != NSNotFound &&
              [appDelegate.urlToOpen rangeOfString:@"</html>"].location != NSNotFound) {
        // Builtin HTML in the virtual button link.
        _urlString = appDelegate.urlToOpen;
        [s2lwebview loadHTMLString:appDelegate.urlToOpen baseURL:nil];
    }else{
        if([appDelegate.urlToOpen hasSuffix:@".mp4"])
        {
            NSRange range = [appDelegate.urlToOpen rangeOfString:@"/" options:NSBackwardsSearch];
            NSString *fileName = [appDelegate.urlToOpen substringFromIndex:range.location+1];
            NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@%@",NSHomeDirectory(),@"/tmp/",fileName]];
            NSLog(@"** LOCAL VIDEO %@ %@ %@",fileName,url,appDelegate.urlToOpen);
            NSError *err;
            NSLog(@"** file exist: %d",[url checkResourceIsReachableAndReturnError:&err]);
            s2lwebview.hidden = YES;
            self.view.backgroundColor = [UIColor blackColor];
            moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
            CGRect frame;
            if (isIPad) {
                self.view.frame = CGRectMake(0, 0, 768, 800 );
                frame = self.view.bounds;
                moviePlayer.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
            }else{
                frame = CGRectMake(0, 0, 320, 373 );
                moviePlayer.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
            }
            moviePlayer.moviePlayer.view.frame = frame;
            [self.view addSubview:moviePlayer.moviePlayer.view];
            moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
            [moviePlayer.moviePlayer prepareToPlay];
            [moviePlayer.moviePlayer play];
            [moviePlayer.moviePlayer setFullscreen:YES animated:YES];
        
        }else{
            NSURL *url = [NSURL URLWithString:appDelegate.urlToOpen];
            [[UIApplication sharedApplication] openURL:url];
            isExternal = YES;
        }
    }
    s2lwebview.delegate = self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// VBR
#pragma mark - IBActions

- (void)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)doneButtonPressed:(id)sender {
    // VBR
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end


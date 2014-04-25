//
//  ASHilfeViewController.m
//  snap2life suite
//
//  Created by Antonio Stilo on 06.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lUtilitiesViewController.h"
#import "ASHilfeGalleryView.h"
#import "Constants.h"
#import "s2lSnapWebViewController.h"
#import "s2lAppDelegate.h"
#import "UtilsPackage.h"
#import "UIButton+UIButton_style.h"

@interface s2lUtilitiesViewController ()

@end

@implementation s2lUtilitiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
               
    }
    return self;
}


-(void)openWebUrl:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSString *urlString = [(UtilsPackage*)[btnList objectAtIndex:btn.tag] href];
    
    NSLog(@"** openWebUrl:%@",urlString);
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    Settings *settings = [pm settings];
    
    if(![[settings settingBrowser] boolValue] && ![urlString hasPrefix:@"mailto:"]){
        UIStoryboard *storyboard = self.storyboard;
        s2lSnapWebViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"web"];
        s2lAppDelegate *appDelegate = (s2lAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.urlToOpen = urlString;
        [self presentViewController:webViewController animated:YES completion:nil];
    }else{
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Utilities";
    
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    scrollView.backgroundColor = [UIColor clearColor];

    PersistenceManager *pm = [PersistenceManager sharedInstance];
    btnList = [[pm utilsPackage] mutableCopy];
    
    [btnList sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    
    for (int i=0; i< btnList.count; i++) {
        UtilsPackage *item = [btnList objectAtIndex:i];
        UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        tmpBtn.frame = CGRectMake((self.view.frame.size.width-200)/2, 40+(i*50), 200, 44);
        [tmpBtn setTitle:item.label forState:UIControlStateNormal];
        tmpBtn.tag = [item.order intValue];
        [tmpBtn addTarget:self action:@selector(openWebUrl:) forControlEvents:UIControlEventTouchUpInside];
        [tmpBtn setStyle];
        [scrollView addSubview:tmpBtn];
    }
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, (btnList.count*44)+220);
    scrollView.frame = self.view.bounds;
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
}

- (void)viewWillLayoutSubviews
{
    
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{

    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}



-(void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    pageControl.currentPage = ((int)round(scrollView.contentOffset.x+10)/320);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

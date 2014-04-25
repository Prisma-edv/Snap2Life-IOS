//
//  s2lPageViewViewController.m
//  snap2life suite
//
//  Created by Volker Brendel on 04.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lGalleryViewController.h"
#import "Constants.h"
#import "GalleryItemDef.h"
#import "GalleryImageDef.h"
#import "GalleryImage.h"
#import "PersistenceManager.h"
#import "S2LDownloadPopOverViewController.h"
#import "s2lSnapWebViewController.h"
#import "s2lAppDelegate.h"
#import "S2LPackageUtils.h"

@interface s2lGalleryViewController ()

@end

@implementation s2lGalleryViewController

@synthesize pageControl, scroll, popover,selectedPackage;//, data,maximumWidth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(void)viewDidLayoutSubviews
{
    /*
    if (!isIPad) {
         NSLog(@"s2lPageViewViewController.viewDidLayoutSubviews");
        int width = 0;
        int height = 0;
        int y = 386;
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            width = 320;
            height = 420;
        }else{
            width = 480;
            height = 280;
            y = 230;
        }
        int x = 0;
        int contentWidth = 0;
        scroll.frame = CGRectMake(0, 0, width, 420);
        for (int i = 0; i < scroll.subviews.count; i++) {
            UIImageView *v = (UIImageView*)[scroll.subviews objectAtIndex:i];
            if (i>0) {
                UIImageView *vv = (UIImageView*)[scroll.subviews objectAtIndex:i-1];
                x = vv.frame.origin.x + vv.frame.size.width;
            }
            v.frame = CGRectMake(x, 0, v.image.size.width, height);
            contentWidth += v.image.size.width;
        }
        scroll.contentSize = CGSizeMake(contentWidth, height);
        pageControl.frame = CGRectMake((width-pageControl.frame.size.width)/2, y, pageControl.frame.size.width, pageControl.frame.size.height);
    }
     */
}

-(void)openWebUrl:(NSString *)urlString
{
    UIStoryboard *storyboard = self.storyboard;
    s2lSnapWebViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"web"];
    s2lAppDelegate *appDelegate = (s2lAppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.urlToOpen = urlString;
    [self presentViewController:webViewController animated:YES completion:nil];
    
}

-(void)linkHandler:(id)sender
{
    
    PersistenceManager* persistentManager = [PersistenceManager sharedInstance];
    GalleryItem *galleryItem = [persistentManager galleryItemForURL:[[persistentManager settings] packageDownloadURL]];
    NSMutableArray *data = [NSMutableArray arrayWithArray:[galleryItem.images allObjects]];
    [data sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    
    UIButton *selectedBtn = (UIButton*)sender;
    NSString *link = [[data objectAtIndex:selectedBtn.tag] link];
    NSLog(@"** PAGE GALLERY TAPP %u %@",selectedBtn.tag,link);
    [self openWebUrl:link];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"s2lPageViewViewController.viewWillAppear");
    
    [super viewDidAppear:animated];
    
    
    self.title = @"Gallery";
    
    int width = 320;
    if(isIPad)width = 768;
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    for(UIView *v in scroll.subviews)[v removeFromSuperview];
    
    
    PersistenceManager* persistentManager = [PersistenceManager sharedInstance];
    GalleryItem *galleryItem = [persistentManager galleryItemForURL:selectedPackage];
    if (galleryItem == nil) {
        galleryItem = [persistentManager defaultGalleryItem];
        NSLog(@"2galleryItem %@",galleryItem);
    }
    NSMutableArray *data = [NSMutableArray arrayWithArray:[galleryItem.images allObjects]];
    NSLog(@"DATA %@",data);
    // Sort the array by the order attribute.
    [data sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];

    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GalleryImage *image = (GalleryImage*)obj;
        UIImageView *imageView;
        if (!isIPad) {
            if ([UIScreen mainScreen].bounds.size.height >= 568.0) {
                // iPhone 5
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*idx, (self.view.frame.size.height-508-160)/2, width, 508)];
            }
            else {
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*idx, (self.view.frame.size.height-420-160)/2, width, 420)];
            }
        }else{
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*idx, (self.view.frame.size.height-1024)/2, width, 1024)];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        UIImage *img = [UIImage imageWithContentsOfFile:image.pathToFile];
        NSLog(@"IMG Gallery: %@",img);
        imageView.image = img;
        //if(img.size.width >= maximumWidth) maximumWidth = img.size.width;
        
        if (image.link != nil && ![image.link isEqualToString:@""]) {
            NSLog(@"<<<<<<< <<<<< %@",image.link);
            UIButton *trspBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            trspBtn.frame = CGRectMake(0, 0, 640, 1000);
            trspBtn.tag = idx;
            [trspBtn addTarget:self action:@selector(linkHandler:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:trspBtn];
        }
        imageView.userInteractionEnabled = YES;
        [scroll addSubview:imageView];

    }];
    
    pageControl.numberOfPages = data.count;
    scroll.pagingEnabled = NO;
    scroll.frame = CGRectMake(scroll.frame.origin.x, scroll.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    scroll.contentSize = CGSizeMake(width*data.count, 400);
    scroll.scrollEnabled = YES;
    NSLog(@"** scroll contentsize %@ - %f",scroll,scroll.contentSize.width);
    scroll.showsHorizontalScrollIndicator = NO;
    pageControl.hidden = YES;
    // Define a success block to be run after gallery download or whenever the gallery is entered.
    
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //if (DEBUG_VERBOSE) NSLog(@"s2lPageViewViewController.scrollViewDidScroll");
    pageControl.currentPage = scrollView.contentOffset.x/320;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
@end

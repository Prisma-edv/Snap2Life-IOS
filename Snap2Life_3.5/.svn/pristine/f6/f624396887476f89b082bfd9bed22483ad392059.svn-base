//
//  ASHilfeViewController.m
//  snap2life suite
//
//  Created by Antonio Stilo on 06.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lHelpViewController.h"
#import "ASHilfeGalleryView.h"
#import "Constants.h"
#import "PersistenceManager.h"
#import "s2lAppDelegate.h"
#import "GalleryDef.h"


@interface s2lHelpViewController ()

@end

@implementation s2lHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ASHilfe viewDidLoad");
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    scrollView.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    NSDictionary *dictForTutorial1 = [NSDictionary dictionaryWithObjectsAndKeys:@"tutorial1.png",@"image",NSLocalizedString(@"tutorial_title_1", nil),@"title",NSLocalizedString(@"tutorial_descr_1", nil),@"description", nil];
    
    NSDictionary *dictForTutorial2 = [NSDictionary dictionaryWithObjectsAndKeys:@"tutorial2.png",@"image",NSLocalizedString(@"tutorial_title_2", nil),@"title",NSLocalizedString(@"tutorial_descr_2", nil),@"description", nil];

    NSLog(@"NSLocalizedString %@",NSLocalizedString(@"tutorial_descr_2", nil));
    NSDictionary *dictForTutorial3 = [NSDictionary dictionaryWithObjectsAndKeys:@"tutorial3.png",@"image",NSLocalizedString(@"tutorial_title_3", nil),@"title",NSLocalizedString(@"tutorial_descr_3", nil),@"description", nil];
    
    NSArray *viewsContnet = [NSArray arrayWithObjects:dictForTutorial1,dictForTutorial2,dictForTutorial3, nil];

    for (int i = 0; i < viewsContnet.count; i++)
    {
        ASHilfeGalleryView *galleryItem = [[ASHilfeGalleryView alloc] initWithFrame:CGRectMake(i*320, 0, scrollView.frame.size.width, scrollView.frame.size.height) andAttributes:[viewsContnet objectAtIndex:i]];
        [scrollView addSubview:galleryItem];
    }
    
}


- (void)viewWillLayoutSubviews
{
    
    if (isIPad) {
        pageControl.hidden = YES;
        CGRect screen = [[UIScreen mainScreen] bounds];
        NSLog(@" ** screen %f %f",screen.size.width, screen.size.height);
        for(int i=0; i<scrollView.subviews.count;i++)
        {
            ASHilfeGalleryView *v = (ASHilfeGalleryView*)[scrollView.subviews objectAtIndex:i];
            NSLog(@"** i = %i",i);
            [v buildToInterfaceOrientation:self.interfaceOrientation];
            v.frame = CGRectMake((768-600)/2,280*i, v.frame.size.width, v.frame.size.height);
        }
        
        scrollView.contentSize = CGSizeMake(768, 1000);
    }else{
        CGFloat width;
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            scrollView.frame = CGRectMake(0, 0, 320, 372);
            scrollView.contentSize = CGSizeMake(320*3, 0);
            pageControl.frame = CGRectMake((320-38)/2, 360, 38, 36);
            width = 320;
        }else{
            scrollView.frame = CGRectMake(0, 0, 480, 240);
            scrollView.contentSize = CGSizeMake(480*3, 0);
            pageControl.frame = CGRectMake((480-38)/2, 220, 38, 36);
            width = 480;
            [scrollView scrollRectToVisible:CGRectMake((width*pageControl.currentPage), 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
        }
        
        int i = 0;
        for(ASHilfeGalleryView *v in scrollView.subviews)
        {
            v.frame = CGRectMake(i*width, 0, v.frame.size.width, v.frame.size.height);
            [(ASHilfeGalleryView*)v buildToInterfaceOrientation:self.interfaceOrientation];
            i++;
        }
    }

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

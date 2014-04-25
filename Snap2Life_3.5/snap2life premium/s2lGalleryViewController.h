//
//  s2lPageViewViewController.h
//  snap2life suite
//
//  Created by Volker Brendel on 04.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface s2lGalleryViewController : UIViewController <UIScrollViewDelegate,UIPopoverControllerDelegate>

@property (nonatomic,strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) IBOutlet UIScrollView *scroll;
@property (nonatomic,strong)  UIPopoverController* popover;
@property (nonatomic,strong) NSString *selectedPackage;
//@property (nonatomic,strong) NSMutableArray *data;
//@property (nonatomic) int maximumWidth;


@end

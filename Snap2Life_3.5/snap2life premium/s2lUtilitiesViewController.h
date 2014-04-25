//
//  ASHilfeViewController.h
//  snap2life suite
//
//  Created by Antonio Stilo on 06.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface s2lUtilitiesViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    
    NSMutableArray *btnList;

}
-(void)openWebUrl:(id)sender;

@end

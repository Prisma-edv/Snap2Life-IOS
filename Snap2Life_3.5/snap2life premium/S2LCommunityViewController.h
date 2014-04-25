//
//  S2LCommunityViewController.h
//  snap2life suite
//
//  Created by iOS on 12.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S2LCommunityViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UICollectionView *table;
    BOOL isReady;
}

@property (nonatomic, strong) NSArray *data;
-(void)prepareTable;

@end

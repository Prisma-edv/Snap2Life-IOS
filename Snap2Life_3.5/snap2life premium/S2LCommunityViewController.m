//
//  S2LCommunityViewController.m
//  snap2life suite
//
//  Created by iOS on 12.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LCommunityViewController.h"
#import "S2LCommunityManager.h"
#import "S2LSnapCell.h"
#import "PersistenceManager.h"
#import "S2LCommentViewController.h"
#import "Constants.h"

#define kCellIdentifier @"communityCell"

@interface S2LCommunityViewController ()

@end

@implementation S2LCommunityViewController
@synthesize data;

#pragma mark UITABLEVIE

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.frame.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return data.count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    S2LSnapCell *cell = (S2LSnapCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.snapDef = [data objectAtIndex:indexPath.row];
    cell.parent = self;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    if (!isReady) {
        self.navigationItem.rightBarButtonItem = nil;
        isReady = YES;
        
        [UIView animateWithDuration:1.0 animations:^{
            table.alpha = 1.0;
        }];
    }
    
    return cell;
}

#pragma mark UIVIEWCONTROLLER

-(void)prepareTable
{
    
    isReady = NO;
    table.alpha = 0.0;
    
    UIActivityIndicatorView *preloader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [preloader startAnimating];
    
    UIBarButtonItem *preloaderItem = [[UIBarButtonItem alloc] initWithCustomView:preloader];
    [self.navigationItem setRightBarButtonItem:preloaderItem];
    
    NSMutableArray *effectiveListID = [NSMutableArray array];
    NSMutableArray *effectiveList = [NSMutableArray array];
    S2LCommunityManager *cm = [S2LCommunityManager sharedInstance];
    [cm loadSnapListWithCompletition:^(NSArray *snapsDefs) {
        
        NSArray *snapList = [[snapsDefs reverseObjectEnumerator] allObjects];
        
        for (int i = 0; i < snapList.count; i++) {
            S2LCommunitySnapDef *tmp = (S2LCommunitySnapDef*)[snapList objectAtIndex:i];
            if (![effectiveListID containsObject:tmp.snapId]) {
                [effectiveList addObject:tmp];
                [effectiveListID addObject:tmp.snapId];
                
                [cm loadSnap:tmp.snapId withCompletition:^(UIImage *snap) {
                    [cm loadComments:tmp.snapId withCompletition:^(NSArray *comments) {
                        self.data = [[effectiveList reverseObjectEnumerator] allObjects];
                        table.frame = self.view.bounds;
                        [table reloadData];
                    }];
                }];
            }
        }
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Community";
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    self.navigationController.navigationBarHidden = NO;
    
    int height = 184;
    if (isIPad) {
        height = 360;
    }
    
    table.pagingEnabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

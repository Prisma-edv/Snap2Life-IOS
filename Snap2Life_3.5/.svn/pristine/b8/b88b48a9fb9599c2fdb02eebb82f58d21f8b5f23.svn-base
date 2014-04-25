//
//  S2LSnapCell.h
//  snap2life suite
//
//  Created by iOS on 12.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "S2LCommunitySnapDef.h"
#import "ADPopupView.h"

@interface S2LSnapCell : UICollectionViewCell <UITableViewDataSource,UITableViewDelegate,ADPopupViewDelegate>
{
    
    NSArray *oldComments;
    
    UIActivityIndicatorView *preloader;
    
    ADPopupView *shearPopUP;
    ADPopupView *commentPopUP;
    BOOL isChanging;
}

@property (nonatomic) IBOutlet UILabel *title;

@property (nonatomic) IBOutlet UIImageView *snapImageView;
@property (nonatomic) IBOutlet UIImageView *avatarImageView;
@property (nonatomic) IBOutlet UITableView *table;

@property (nonatomic) IBOutlet UIButton *commentBtn;
@property (nonatomic) IBOutlet UIButton *shearBtn;


@property (nonatomic,unsafe_unretained) UIViewController *parent;
@property (nonatomic,strong) S2LCommunitySnapDef *snapDef;

-(IBAction)shearHandler;
-(IBAction)commentHandler;

@end

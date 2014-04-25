//
//  s2lInfoViewController.h
//  snap2life suite
//
//  Created by Antonio Stilo on 08.04.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface s2lFAQViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *isOpens;
@property (nonatomic,unsafe_unretained) IBOutlet id delegate;

-(void)openCell:(int)index;

@end

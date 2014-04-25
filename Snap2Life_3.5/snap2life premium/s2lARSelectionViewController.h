//
//  s2lARSelectionViewController.h
//  snap2life suite
//
//  Created by Antonio Stilo on 26.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface s2lARSelectionViewController : UITableViewController
{
    NSMutableArray *_data;
    BOOL _editing;
    UILabel *noRecords;
    NSUInteger _selected;

}

@property (nonatomic,strong) NSMutableArray *data;
@property BOOL isModal;

@end

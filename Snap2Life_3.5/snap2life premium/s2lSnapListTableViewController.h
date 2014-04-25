//
//  s2lSnapListTableViewController.h
//  snap2life suite
//
//  Created by Volker Brendel on 22.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface s2lSnapListTableViewController : UITableViewController

- (IBAction)editingButtonPressed:(id)sender;

- (IBAction)cancelButtonPressed:(id)sender;

- (IBAction)doneButtonPressed:(id)sender;

@property (nonatomic, strong) NSMutableArray *snaps;

@end

//
//  s2lMasterViewController.h
//  snap2life premium
//
//  Created by Volker Brendel on 18.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class s2lDetailViewController;

@interface s2lMasterViewController : UITableViewController

@property (strong, nonatomic) s2lDetailViewController *detailViewController;

- (IBAction)doneButtonPressed:(id)sender;

@end

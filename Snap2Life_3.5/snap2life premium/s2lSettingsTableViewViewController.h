//
//  s2lSettingsTableViewViewController.h
//  snap2life suite
//
//  Created by Antonio Stilo on 26.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DBDelegate; // Forward references
@protocol SettingsDelegate;

@interface s2lSettingsTableViewViewController : UITableViewController

@property (nonatomic, unsafe_unretained) id<DBDelegate> dbDelegate;
@property (nonatomic, unsafe_unretained) id<SettingsDelegate> settingsDelegate;

@end

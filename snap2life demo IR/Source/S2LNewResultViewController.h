//
//  S2LNewResultViewController.h
//  snap2life suite
//
//  Created by Antonio_Stilo on 11/21/13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectDef.h"

@interface S2LNewResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate>
{
    IBOutlet UIScrollView* scroll;
    IBOutlet UILabel* titleLabel;
    IBOutlet UILabel* descriptionLabel;
    IBOutlet UIImageView* background;
    IBOutlet UITableView* table;
    
    NSArray *features;
    NSString *snapID;
    
    BOOL isFirst;
    
}

//@property (nonatomic, unsafe_unretained) IBOutlet id<WebViewDelegate> delegate;

@property (nonatomic) int index;
@property (nonatomic, strong)ObjectDef* object;

@end

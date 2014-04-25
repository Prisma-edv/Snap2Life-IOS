//
//  ASVoteView.h
//  snap2life suite
//
//  Created by Antonio Stilo on 15.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "History.h"
#import "s2lTrackingUtils.h"

@interface ASVoteView : UIView
{
    History *_model;
    s2lTrackingUtils *sender;
}
@property (nonatomic,strong) History *model;

- (id)initWithFrame:(CGRect)frame withHistory:(History*)history;
-(void)updateValue:(NSInteger)value;

@end

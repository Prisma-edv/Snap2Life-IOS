//
//  ASVoteView.m
//  snap2life suite
//
//  Created by Antonio Stilo on 15.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "ASVoteView.h"
#import "PersistenceManager.h"

@implementation ASVoteView
@synthesize model = _model;

-(void)voteHandler:(id)bsender
{
    NSLog(@"** Vote %@ %d",self.model,[self.model.snapHasVoted boolValue]);
    //if (![self.model.snapHasVoted boolValue]) {
    
        UIButton *btn = (UIButton*)bsender;
        
        self.model.snapHasVoted = [NSNumber numberWithBool:YES];
        self.model.snapVoteValue = [NSNumber numberWithInt:[btn tag]];
    
        [[PersistenceManager sharedInstance] saveAll];
        NSLog(@"[self.model.snapHasVoted boolValue] %d",[self.model.snapHasVoted boolValue]);
        NSLog(@"self.model.snapVoteValue %d",[self.model.snapVoteValue integerValue]);
    
    [self updateValue:btn.tag];
    
    [sender sendVote:[NSString stringWithFormat:@"%u",btn.tag] andObjectID:[self.model.snapID integerValue]];
    
   /*}else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vote." message:@"You already voted for this Snap." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }*/
}

-(void)updateValue:(NSInteger)value
{
    for (int i = 0; i < 5; i++)
    {
        UIButton *tempBtn = (UIButton*)[self.subviews objectAtIndex:i];
        if (i < value) {
            tempBtn.selected = YES;
        }else{
            tempBtn.selected = NO;
        }
    }
}

- (id)initWithFrame:(CGRect)frame withHistory:(History*)history
{
    self = [super initWithFrame:frame];
    if (self) {
        sender = [[s2lTrackingUtils alloc] init];
        self.model = history;
        NSLog(@"** self.model %@",self.model);
        self.backgroundColor = [UIColor clearColor];
        //self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        int width = 320;
        int mWidth = 45;
        if(isIPad){
            width = 768;
            mWidth = 209;
        }
        //self.frame = CGRectMake(0, 0, width, 60);
       // CGFloat mWidth = ((width-250.0)/2)-50;
        for (int i=0; i < 5; i++) {
            UIButton *tempStar = [UIButton buttonWithType:UIButtonTypeCustom];
            tempStar.tag = (i+1);
            tempStar.titleLabel.font = [UIFont boldSystemFontOfSize:11];
            //[tempStar setTitle:[NSString stringWithFormat:@"%u",tempStar.tag] forState:UIControlStateNormal];
            [tempStar setBackgroundImage:[UIImage imageNamed:@"_rating-star.png"] forState:UIControlStateNormal];
            [tempStar setBackgroundImage:[UIImage imageNamed:@"_rating-star-selected.png"] forState:UIControlStateSelected];
            tempStar.frame = CGRectMake(12+(i*36), 6, 31, 31);
            if(i < [self.model.snapVoteValue integerValue])tempStar.selected = YES;
            [tempStar addTarget:self  action:@selector(voteHandler:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:tempStar];
        }
    }
    return self;
}

@end

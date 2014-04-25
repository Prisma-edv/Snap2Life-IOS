//
//  s2lHistoryCell.m
//  snap2life suite
//
//  Created by Antonio Stilo on 18.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lHistoryCell.h"
#import "PersistenceManager.h"
#import "S2LProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@implementation s2lHistoryCell
@synthesize history = _history;
@synthesize delegate;
@synthesize isSelectable;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    }
    
    return self;
}

-(IBAction)pdfSenedableHandler
{

    BOOL value = [self.history.snapToSendForPdf boolValue];
    NSLog(@"** pdfSenedableHandler %d",value);
    value = !value;
    
    self.history.snapToSendForPdf = [NSNumber numberWithBool:value];
    [[PersistenceManager sharedInstance] saveAll];
    
    [[(S2LProfileViewController*)delegate table] reloadData];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 44, 44);
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
    if (trasparentButton == nil  && isSelectable) {
        trasparentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        trasparentButton.frame = CGRectMake(self.frame.size.width-44, 0, 44, 44);
        //[trasparentButton setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
        [trasparentButton addTarget:self action:@selector(pdfSenedableHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:trasparentButton];
        [self bringSubviewToFront:trasparentButton];
    }
    
    self.imageView.image = [UIImage imageWithData:[self.history snapImage]];
    
    self.textLabel.font = [UIFont boldSystemFontOfSize:13];
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.textLabel.numberOfLines = 2;
    self.textLabel.frame = CGRectMake(50,self.textLabel.frame.origin.y, 130, 30);
    
    // Get a formatter for the date field according to the currentLocale.
    

    NSString *dateString = [dateFormatter stringFromDate:[self.history snapDate]];
    NSString *value;

    if(self.history.snapTitle != nil) value = [NSString stringWithFormat:@"%@\n%@",self.history.snapTitle,dateString];
    else
        value = dateString;
    self.textLabel.text = value;

    self.detailTextLabel.text = @"";//(snapRecognized)? @"REC": @"no-rec";
    self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x
                                            , (84-self.detailTextLabel.frame.size.height)/2, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryView.backgroundColor = [UIColor whiteColor];
}

@end

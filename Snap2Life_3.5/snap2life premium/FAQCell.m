//
//  FAQCell.m
//  Snap2Life
//
//  Created by Antonio Stilo on 29.04.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "FAQCell.h"
#import "Constants.h"
#import "s2lFAQViewController.h"

@implementation FAQCell
@synthesize data,isOpen,origin,delegate,index;

-(void)pressed
{
    [(s2lFAQViewController*)delegate openCell:index];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
        //isOpen = NO;
        origin = CGPointMake(0, self.frame.origin.y);
        
        int width = 320;
        if (isIPad) {
            width = 768;
        }
        
        UIImage *img = [UIImage imageNamed:@"faq_arrow.png"];
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, img.size.width, img.size.height)];
        icon.image = img;
        [self.contentView addSubview:icon];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(30, 4, width-70,44)];
        label.font = [UIFont boldSystemFontOfSize:13];
        label.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
        label.numberOfLines = 2;
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        
        separator = [[UIView alloc]initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, width, 1)];
        separator.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        [self.contentView addSubview:separator];
        
        custom = [[UILabel alloc] initWithFrame:CGRectMake(30, self.textLabel.frame.origin.y+self.textLabel.frame.size.height+4, width-70, 44)];
        custom.textAlignment = NSTextAlignmentLeft;
        custom.hidden = YES;
        custom.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:custom];
        
        secondSeparator = [[UIView alloc]initWithFrame:CGRectMake(0, custom.frame.origin.y+custom.frame.size.height, width, 1)];
        secondSeparator.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:secondSeparator];
        secondSeparator.hidden = YES;
       
        UIButton *trspBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        trspBtn.frame = CGRectMake(0, 0, width, 44);
        [trspBtn addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:trspBtn];
        
    }
    return self;
}

-(void)layoutSubviews
{
    //
    [super layoutSubviews];
    int openHeight = 220;
    int width = 320;
    if (isIPad) {
        width = 768;
        openHeight = 130;
    }
    label.text = [data objectForKey:@"label"];
    label.frame = CGRectMake(30, 4, width-70,label.frame.size.height);
    [label sizeToFit];
    separator.frame = CGRectMake(0, label.frame.origin.y+label.frame.size.height, width, 1);
    
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 44);
    
    custom.font = [UIFont systemFontOfSize:11];
    custom.numberOfLines = 12;
    //custom.textColor = [UIColor purpleColor];
    
    NSString *detail = [data objectForKey:@"value"];
    custom.text = detail;
    UIImage *img;
    int height;
    if(isOpen){
        height = openHeight;
        custom.hidden = NO;
        secondSeparator.hidden = NO;
        img = [UIImage imageNamed:@"faq_arrowSelected.png"];
        CGSize size = [detail sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(width-70, 300)];
        custom.frame = CGRectMake(30, label.frame.origin.y+label.frame.size.height+4, size.width, size.height);
        [custom sizeToFit];
        //CGFloat height = label.frame.origin.y+label.frame.size.height+custom.frame.size.height+10;
         // self.frame = CGRectMake(origin.x, origin.y, width, height);
    }else{
        height = 44;
        custom.hidden = YES;
        secondSeparator.hidden = YES;
        img = [UIImage imageNamed:@"faq_arrow.png"];
        custom.frame = CGRectMake(30, self.textLabel.frame.origin.y+self.textLabel.frame.size.height, width-70, 44);
        //self.frame = CGRectMake(origin.x, origin.y, width, 44.0);
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    secondSeparator.frame = CGRectMake(0, height-2, width, 1);
    icon.image = img;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

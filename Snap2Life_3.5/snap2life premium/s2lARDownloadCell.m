//
//  s2lARDownloadCell.m
//  snap2life suite
//
//  Created by Antonio Stilo on 27.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lARDownloadCell.h"
#import "Constants.h"

@implementation s2lARDownloadCell
@synthesize dateLabel = _dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y-6, 100, 16)];
            _dateLabel.backgroundColor = [UIColor clearColor];
            _dateLabel.font = [UIFont systemFontOfSize:9];
            _dateLabel.textColor = [UIColor darkGrayColor];
            [self.contentView addSubview:_dateLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    _dateLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y-4, _dateLabel.frame.size.width, _dateLabel.frame.size.height);
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y+8, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    

}

@end

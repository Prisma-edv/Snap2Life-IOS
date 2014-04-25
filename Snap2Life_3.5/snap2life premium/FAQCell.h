//
//  FAQCell.h
//  Snap2Life
//
//  Created by Antonio Stilo on 29.04.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQCell : UITableViewCell
{
    UILabel *custom;
    UILabel *label;
    UIImageView *icon;
    
    UIView *separator;
    UIView *secondSeparator;
}

@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,weak) id delegate;
@property BOOL isOpen;
@property int index;

@property CGPoint origin;

@end

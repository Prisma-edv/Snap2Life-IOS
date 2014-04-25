//
//  QCARVirtualButton.h
//  S2LAR_IOS_1.0
//
//  Created by Antonio Stilo on 25.09.13.
//  Copyright (c) 2013 prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QCARVirtualButton : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * rectangle;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * texturePath;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSNumber * order;

@end

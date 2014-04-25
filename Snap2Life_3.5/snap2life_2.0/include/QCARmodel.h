//
//  QCARmodel.h
//  S2LAR_IOS_1.0
//
//  Created by Antonio Stilo on 27.09.13.
//  Copyright (c) 2013 prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QCARVirtualButton;

@interface QCARmodel : NSManagedObject

@property (nonatomic, retain) NSString * imageTargetName;
@property (nonatomic, retain) NSString * objectPath;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * texturePath;
@property (nonatomic, retain) NSSet *buttons;
@end

@interface QCARmodel (CoreDataGeneratedAccessors)

- (void)addButtonsObject:(QCARVirtualButton *)value;
- (void)removeButtonsObject:(QCARVirtualButton *)value;
- (void)addButtons:(NSSet *)values;
- (void)removeButtons:(NSSet *)values;

@end

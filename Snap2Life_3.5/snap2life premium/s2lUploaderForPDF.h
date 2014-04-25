//
//  s2lUploader.h
//  snap2life suite
//
//  Created by Antonio Stilo on 06.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDataObject.h"

typedef enum {
    kStarted,
    kProgress,
    kFinished
}UploaderStatus;

@interface s2lUploaderForPDF : NSObject
{
    NSMutableArray *_imagesList;
    UploaderStatus status;
    int currentImageIndex;
}

@property (nonatomic,strong) NSMutableArray *imagesList;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, unsafe_unretained) AppDataObject *ado;
@property NSTimeInterval milis;
@property BOOL alreadyAlerted;

-(void)startUploading:(NSArray*)incomingList;

@end

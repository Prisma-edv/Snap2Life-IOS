//
//  S2LSerializerDownload.h
//  S2LAR_IOS_1.0
//
//  Created by Antonio Stilo on 23.09.13.
//  Copyright (c) 2013 prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCARTrackingDef.h"
#import "GalleryDef.h"
#import "DDXMLDocument.h"

@interface S2LSerializerDownload : NSObject

- (QCARTrackingDef*)deserializeARpackageDef:(DDXMLDocument *)document;
- (GalleryDef*)deserializeGalleryDef:(DDXMLDocument *)document;

@end

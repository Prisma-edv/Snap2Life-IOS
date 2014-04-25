//
//  PackageUtils.h
//  snap2life suite
//
//  Created by prisma on 14.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCARTrackingDef.h"
#import "GalleryDef.h"

@interface S2LPackageUtils : NSObject

// Iterates through all downloadable URLs in an AR package, storing unique URLs in an array.
// If wished a remote path may be prepended to all file names.
+ (NSArray*)extractUniqueURLsFromARPackageDef:(QCARTrackingDef*)arPackageDef prependingPath:(NSString*)relPath;


// Iterates through all downloadable URLs in a Gallery package, storing unique URLs in an array.
// The hrefs of the image can be made relative to their item packageHrefs.
+ (NSArray*)extractUniqueURLsFromGalleryDef:(GalleryDef*)galleryDef relativePaths:(BOOL)rel;

+(NSString*)extractName:(NSString*)urlPath;

+ (NSArray*)extractUniqueURLsFromARPackageDefLange:(QCARTrackingDef*)arPackageDef prependingPath:(NSString*)relPath;

@end

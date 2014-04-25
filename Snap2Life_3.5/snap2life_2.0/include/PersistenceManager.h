//
//  PersistenceManager.h
//  snap2life suite
//
//  Object manager for handling all access to the local database.
//
//  Created by prisma on 19.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "History.h"
#import "Settings.h"
#import "QCARTrackingDef.h"
#import "GalleryPackage.h"
#import "GalleryItem.h"
#import "GalleryDef.h"
#import "ARpackage.h"
#import "Profile.h"

@interface PersistenceManager : NSObject

@property (nonatomic,readonly,retain) Settings* settings;
@property (nonatomic,readonly,retain) Profile* profile;

// Access to the singleton instance.
+ (id)sharedInstance;

-(void)deleteAllHistoriesOlderThenDays:(NSInteger)days;

// Checks if a string is a URL of the type "http://", "mailto:" etc.
+ (BOOL)isUrl:(NSString*)urlString;

// Returns all History instances as an autoreleased NSMutableArray.
- (NSMutableArray*)allHistories;

// Returns a new autoreleased History instance created in the managed object context
- (History*)createHistory;

// Deletes a History instance from the managed context.
- (void)deleteHistory:(History*) toDelete;

// Deletes a specific History from the ordered list of Histories.
- (BOOL)removeHistoryItem:(History*)history;

// Retrieves a list of all downloadURLs from which models have been loaded.
- (NSArray*)allARdownloadURLs;

// Retrieves the ARpackage for a given downloadURL, returning nil if not found.
- (ARpackage*)arPackageForURL:(NSString*)downloadURL;

// Retrieves a list of all ARpackages for models which have been loaded.
- (NSArray*)allARpackages;

// Saves all managed objects to the db. Returns YES if persistence was possible.
- (BOOL)saveAll;

// Discard all changes done to the DB since the last save.
- (void)discardChanges;

// Enters a complete ARpackage object graph into the database for the given ARPackageDef. Returns YES if persistence was possible.
- (BOOL)persistARpackageForQCARPackageDef:(QCARTrackingDef*)arPackageDef forURL:(NSString*)downloadURL withFilePath:(NSString*)path andMemoryFootPrint:(NSInteger)totalWeight;

// Deletes a Package instance from the managed context.
- (void)deletePackage:(ARpackage*) toDelete;

// Enters a complete GalleryPackage object graph into the database for the given GalleryDef. Returns YES if persistence was possible.
- (BOOL)persistGalleryPackageForGalleryDef:(GalleryDef*)galleryDef;

// Retrieves the singleton GalleryPackage, returning nil if not found.
- (GalleryPackage*)galleryPackage;

// Retrieves an ordered list of gallery items with their AR packageURLs and labels.
- (NSArray*)allGalleryItems;

// Retrieves the item and a list of image data and captions for the AR package.
- (GalleryItem*)galleryItemForURL:(NSString*)arpackageUrl;

-(GalleryItem*)defaultGalleryItem;

-(void)interactionLogItemWithLink:(NSString*)link withTargetName:(NSString*)targetName;
// Create an Interaction Log Item
-(void)interactionLogItemWithLink:(NSString*)link withTargetName:(NSString*)targetName andType:(NSString*)_type;

// Retrieves a list of all InteractionLogs currently waiting to be sent to the server.
- (NSArray*)allInteractions;

// Deletes all Interactions, normally to be called after being sent to the server.
- (void)deleteAllInteractions;

-(NSArray*)utilsPackage;


@end

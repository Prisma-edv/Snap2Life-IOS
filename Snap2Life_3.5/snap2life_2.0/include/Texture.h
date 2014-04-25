/*==============================================================================
 Copyright (c) 2010-2013 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/


#import <Foundation/Foundation.h>

@interface Texture : NSObject {
    int width;
    int height;
    int channels;
    int textureID;
    unsigned char* pngData;
}

@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) int channels;
@property (nonatomic) int textureID;
@property (nonatomic) unsigned char* pngData;

- (BOOL)loadImage:(NSString*)filename;

@end

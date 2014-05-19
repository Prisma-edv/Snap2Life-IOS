//
//  IRConstants.h
//  Snap2LifeIR
//
//  Created by Antonio Stilo on 02.09.13.
//  Copyright (c) 2013 Prisma-edv. All rights reserved.
//


//Tune this values to modify the way the app communicates with the server
#define kMAX_RES_IMAGE 400
#define kREQUEST_IMAGE_KEY @"image"
#define kREQUEST_METADATA_KEY @"metadata.xml"
#define kSUBCAT_ID @"demo"
#define kSERVER_URL_API2 @"https://patriots.snap2life.de/modus/rest/api2/"
/////////////////
#define kINSERT_SUBCAT_KEY @"demo"
#define kFEATUREGROUPS_VERSION 18
#define kFEATUREGROUP_ID 1
#define kFEATURE_ID 3
#define kFEATURE_TYPE 8

//Package name is transmited on each request in an EXTRA field, this field is very important
//for the server to recognise from which app the request is comming
#define kPACKAGE_NAME @"de.prisma.snap2life"
#define kAPP_VERSION @"demo"
//This text string will be transmitted on each request, it is the base64 encoded string
//of the USERNAME:PASSWORD combination example "me:mypass".
#define kBASE64_AUTH_API2 @"ZGVtbzogZGVtbw=="

//Request Headers and other variables
#define kIMAGE_MULTIPART @"image"
#define kHD_LOCALE @"Modus-Locale"
#define kHD_APP_VER @"Modus-App-Ver"
#define kHD_ZIP @"Modus-Zip"
#define kHD_AUTH @"Modus-Authorization"
#define kHD_IMEI @"Modus-Imei"
#define kHD_GPS @"Modus-Gps"
#define kHD_GPS_ACC @"Modus-Gps-Acc"
#define kHD_DEV_OS @"Modus-Dev-Os"
#define kHD_DEV_MODEL @"Modus-Dev-Model"
#define kHD_PACKAGE_NAME @"Modus-Package-Name"
#define kHD_DEV_NAME @"Modus-Device-Name"
#define kHD_2FS @"Modus-2fs"
#define kHD_REQUEST_GROUP @"Modus-Request-Group"
#define kHD_SNAPPERID @"SnapperId"
#define kHD_EMAIL @"EMAIL"
#define kHD_GRYPHOSOBJECTID @"GryphosObjectId"


//ACT_PUT_OPTION: indicates whether a 'PUT' option shall allow the creation of new Gryphos objects by
//sending an HTTP PUT with a new snap after the error screen has appeared; if false the
//toggle present in the settings screen will be disabled.
#define kACT_PUT_OPTION true

//ACT_PUT_WITH_AD_LINK: when the ACT_PUT_OPTION is on, indicates whether a self advertising link shall be inserted into every PUT.
#define kACT_PUT_WITH_AD_LINK true

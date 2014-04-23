//
//  Constants.h
//  Snap2Life
//
//  Created by Alex Corbi on 3/9/11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

// ---- REQUEST

#define ISLITE false

//Package name is transmited on each request in an EXTRA field, this field is very important
//for the server to recognise from which app the request is comming
#define PACKAGE_NAME @"de.prisma.snap2life"

#define APP_ID 598960895 //id from iTunesConnect

//These are the links that will be used normally in the About Screen, are the links where
//the Impressum, further infos are stored. Also the mailto:// adress to use for presenting
//the email form.
#define WEB_URL @"http://www.snap2life.de" //Legacy
#define IMPRESSUM_URL @"http://www.snap2life.de/mobile/impressum.html"
#define CONTACT_URL @"mailto:mail@snap2life.de?subject=Interesse%20an%20snap2life" //Legacy

// ---- USER INTERFACE

//This constants will be used to generate the Scanner and Viewfinder
//graphics dynamically, the rest of the UI Elements should be adapted manually by changing the 
//Images and the .xib files.
#define MAIN_COLOR 0xccdb32
#define SEC_COLOR_1 0xeBebeb
#define SEC_COLOR_2 0x339900
#define SEC_COLOR_3 0xFFFFFF
#define MIN_SIDE 60
#define TITLE 0x333333
#define BACKGROUND 0xebeced
#define FRONT_GREY 0x339900
#define GREY 0x339900
#define GREEN 0x339900

// ---- SNAP ANIMATION SCANNER BAR
// If true, applies "viscosity" to the animation.
#define RUBBER_BAND_ANIMATION true

// ---- MODULE ACTIVATION

//ACT_MULTIFRAME: Indicates that the app should use a Multiframe framework (AVFoundation or QCAR), 
//this flag is mandatory for the use of AR functionalities, to emulate single frame capturing using
//one of the above Frameworks, set NUMBER_OF_PREVIEWFRAMES to 1
#define ACT_MULTIFRAME true   

//ACT_TWOFINGERSNAP: Default is true so the user can choose where he wants it or not, if false the
//toggle present in the settings screen will be disabled.
#define ACT_TWOFINGERSSNAP true

//ACT_AR_MODE: Indicates whether QCAR AR Framework is used or not. If set to False, the app will
//not load the famework on startup and the toggle present in the settings screen will be disabled.
//Depending on the value of ACT_MULTIFRAME, the standar API (if true) or the AVFoundation (if false)
//framework will be used for capturing.
#define ACT_AR_MODE true

//ACT_HISTORY: indicates whether snap history is activated; if false the
//toggle present in the settings screen will be disabled.
#define ACT_HISTORY true

//ACT_SSL: Indicates whether the App uses SSL to communicate with the server, if set to false, a 
//HTTP (not HTTPS) connection will be established and some infos like GPS and IMEI won't be transfered.
//Also, if this is disabled, the GPS Data of the user won't be captured.
#define ACT_SSL  true

//ACT_PUT_OPTION: indicates whether a 'PUT' option shall allow the creation of new Gryphos objects by
//sending an HTTP PUT with a new snap after the error screen has appeared; if false the
//toggle present in the settings screen will be disabled.
#define ACT_PUT_OPTION true

//ACT_PUT_WITH_AD_LINK: when the ACT_PUT_OPTION is on, indicates whether a self advertising link shall be inserted into every PUT.
#define ACT_PUT_WITH_AD_LINK true

//ACT_CIRCLE_CONNECT: indicates whether Circle Connect is activated; if false the
//toggle present in the settings screen will be disabled.
#define ACT_CIRCLE_CONNECT false

#define ACT_BROWSER true

#define SWAP_TO_ROTATE_AR true

// ---- MULTIFRAME

//MULTIFRAME_TIME_WINDOW: Time-window available to make the number of requests specified on
//NUMBER_OF_PREVIEWFRAMES. The app will try to send so many as it can in this time.Value is in ms.
#define MULTIFRAME_TIME_WINDOW 800

//NUMBER_OF_PREVIEWFRAMES: Number of camera frames to send to the server.
#define NUMBER_OF_PREVIEWFRAMES 2

//The number of times frames are skipped in a newly (re-)started camera before being polled.
#define AR_FRAME_SKIP_COUNT 10

#define HISTORY_EXPIRING_DEFAULT 30

// ---- DYNAMIC AR LOADING
#define DYN_AR_LOADING true
#define AR_PACKAGE_XML @"arpackage.xml"
#define AR_STORAGE_DIR @"Library/Caches"
#define AR_STOCK_DIR @"stock"
#define AR_TEMP_DIR @"tmp"
#define AR_STOCK_PACKAGE_URL @"http://www.snap2life.de/content/ar25/snap2life/stock/demo_fb.xml"
#define AR_TIMEOUT 95.0
#define PLAY_JINGLE false


// snap2Life Pro
#define HOWMANY_PUT_LINKS 1
#define LABEL @"editionhoch3 "
#define GALLERY_PACKAGE_URL @"http://www.snap2life.de/content/ar25/snap2life_gallery_pack_pro.xml"

/*
// snap2Life
#define HOWMANY_PUT_LINKS 1
#define LABEL @"snap2life"
#define GALLERY_PACKAGE_URL @"http://www.snap2life.de/content/ar25/snap2life_gallery_fb.xml"
*/
// snap2Life DEMO
//#define GALLERY_PACKAGE_URL @"http://snap2life.de/content/ar25/snap2life_gallery_test.xml"

// ---- DEBUG

//Debug flags to show different infos while executing the App in debug mode.
#define DEBUG_VERBOSE false
#define DEBUG_TIMES false
#define DEBUG_QCAR false

//Utility macro
#define UIColorFromRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


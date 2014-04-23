// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFS2LAppAPIClient.h"
#import "AFKissXMLRequestOperation.h"
#import "AppDataObject.h"

@implementation AFS2LAppAPIClient
@synthesize isReachable;

+ (AFS2LAppAPIClient *)sharedClient {
    static AFS2LAppAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFS2LAppAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kSERVER_URL_API2]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    isReachable = NO;
    [self registerHTTPOperationClass:[AFKissXMLRequestOperation class]];
    [self setParameterEncoding:AFFormURLParameterEncoding];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [self setDefaultHeader:@"Accept" value:@"image/jpg;level=1,text/xml;level=2"];

    [self startRachability];
    
    return self;
}

-(void)startRachability
{
    [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            isReachable = NO;
        } else {
            isReachable = YES;
        }
        
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            isReachable = YES;
        }
    }];
}

-(void)configuringDefaultHeadersWithADO:(AppDataObject*)ado
{
    [self setDefaultHeader:kHD_AUTH value:kBASE64_AUTH_API2];
    [self setDefaultHeader:kHD_APP_VER value:ado.deviceInfo.appVersion];
    [self setDefaultHeader:kHD_LOCALE value:ado.deviceInfo.locale];
    [self setDefaultHeader:kHD_PACKAGE_NAME value:ado.deviceInfo.appId];
    
    
}

@end

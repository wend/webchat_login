//
//  HttpCom.h
//  WeiDotaClient
//
//  Created by scilearn peng on 10/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"
@interface HttpCom : NSObject

+ (HttpCom*) instance;
- (NSDictionary*) sendHttpPostSyncRequest:(NSString*)urlString postData:(NSString*)post;
- (NSDictionary*) sendBackHttpSyncRequest:(NSString*)urlString;
- (NSString*) sendHttpSyncRequest:(NSString*)urlString;
- (void) sendHttpAsyncRequest:(NSString*)urlString  handle:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

@end

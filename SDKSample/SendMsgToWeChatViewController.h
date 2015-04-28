//
//  SendMsgToWeChatViewController.h
//  ApiClient
//
//  Created by Tencent on 12-2-27.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"

@protocol sendMsgToWeChatViewDelegate <NSObject>
- (void) changeScene:(NSInteger)scene;
- (void) sendTextContent;
- (void) sendImageContent;
- (void) sendLinkContent;
- (void) sendMusicContent;
- (void) sendVideoContent;
- (void) sendAppContent;
- (void) sendNonGifContent;
- (void) sendGifContent;
- (void) sendAuthRequest;
- (void) sendFileContent;
- (void) testUrlLength : (NSString*) length;
- (void) openProfile;
- (void) jumpToBizWebview;
- (void) addCardToWXCardPackage;
- (void) batchAddCardToWXCardPackage;
@end

@interface SendMsgToWeChatViewController : UIViewController<UITextViewDelegate,
    UIWebViewDelegate>

@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate,NSObject> delegate;

@property (nonatomic, assign) UIWebView* webView;
@end

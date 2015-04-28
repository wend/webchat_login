//
//  AppDelegate.m
//  ApiClient
//
//  Created by Tencent on 12-2-27.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import "AppDelegate.h"

#import "HttpCom.h"

#define  APPID @"wx23d54af1cbb0f858"
#define  APPSECRET @"c254533648c2e4f0443659ddacd3c1a3"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[SendMsgToWeChatViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[SendMsgToWeChatViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    self.viewController.delegate = self;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //向微信注册
    [WXApi registerApp:@"wx23d54af1cbb0f858" withDescription:@"demo 2.0"];
    
    return YES;
}

-(void) changeScene:(NSInteger)scene
{
    _scene = scene;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        RespForWeChatViewController* controller = [[RespForWeChatViewController alloc]autorelease];
        controller.delegate = self;
        [self.viewController presentModalViewController:controller animated:YES];
    }else if((alertView.tag == 2000 || alertView.tag == 4000) && buttonIndex != alertView.cancelButtonIndex){
        [WXApi registerApp:[alertView textFieldAtIndex:0].text withDescription:@"demo 2.0"];
        
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"请输入tousername" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        view.alertViewStyle = UIAlertViewStylePlainTextInput;
        if (alertView.tag == 2000) {
            view.tag = 3000;
        }else{
            view.tag = 6000;
        }
        [view textFieldAtIndex:0].text = @"gh_877fdb038ace";
        [view show];
        [view release];
    }else if(alertView.tag == 3000 && buttonIndex != alertView.cancelButtonIndex){
        JumpToBizProfileReq *req = [[[JumpToBizProfileReq alloc]init]autorelease];
        req.profileType = WXBizProfileType_Device;
        req.username = [alertView textFieldAtIndex:0].text;
        req.extMsg = @"http://we.qq.com/d/AQCIc9a3EqRfb19z8WnLB6iFNCxX5bO2S3lHwMQL";
        [WXApi sendReq:req];
    }else if(alertView.tag == 6000 && buttonIndex != alertView.cancelButtonIndex){
        JumpToBizWebviewReq *req = [[[JumpToBizWebviewReq alloc]init]autorelease];
        req.tousrname = [alertView textFieldAtIndex:0].text;
        req.extMsg = @"KOoCKdavezBjdj2wJZsq67N2j_g3XEQ5JP_pkLhBYS4";
        req.webType = WXMPWebviewType_Ad;
        [WXApi sendReq:req];
    }

}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
        
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", temp.openID];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
        [alert release];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n附加消息:%@\n", temp.openID, msg.title, msg.description, obj.extInfo, msg.thumbData.length, msg.messageExt];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release]; 
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
        WXMediaMessage *msg = temp.message;
        
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        // 获取CODE
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode];
        [self getTokenByCode:temp.code];
        
        [self getUserInfo];
        [self callServer];
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //[alert show];
        //[alert release];
    }
    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]])
    {
        AddCardToWXCardPackageResp* temp = (AddCardToWXCardPackageResp*)resp;
        NSMutableString* cardStr = [[[NSMutableString alloc] init] autorelease];
        for (WXCardItem* cardItem in temp.cardAry) {
            [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%lu\n",cardItem.cardId,cardItem.extMsg,cardItem.cardState]];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"add card resp" message:cardStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void) sendTextContent
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
    req.bText = YES;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespTextContent
{
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
    resp.bText = YES;
    
    [WXApi sendResp:resp];
}

- (void) sendImageContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res1thumb.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_APP";
    message.messageExt = @"这是第三方带的测试字段";
    message.messageAction = @"<action>dotalist</action>";
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) RespImageContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res1thumb.png"]];
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) sendLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"专访张小龙：产品之上的世界观";
    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req];
}

-(void) RespLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"专访张小龙：产品之上的世界观";
    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

-(void) sendMusicContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"一无所有";
    message.description = @"崔健";
    [message setThumbImage:[UIImage imageNamed:@"res3.jpg"]];
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = @"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4B880E697A0E68980E69C89222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696334382E74632E71712E636F6D2F586B30305156342F4141414130414141414E5430577532394D7A59344D7A63774D4C6735586A4C517747335A50676F47443864704151526643473444442F4E653765776B617A733D2F31303130333334372E6D34613F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D30222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31342E71716D757369632E71712E636F6D2F33303130333334372E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E4B880E697A0E68980E69C89222C22736F6E675F4944223A3130333334372C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E5B494E581A5222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D313574414141416A41414141477A4C36445039536A457A525467304E7A38774E446E752B6473483833344843756B5041576B6D48316C4A434E626F4D34394E4E7A754450444A647A7A45304F513D3D2F33303130333334372E6D70333F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D3026616D703B73747265616D5F706F733D35227D";
    ext.musicDataUrl = @"http://stream20.qqmusic.qq.com/32464723.mp3";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespMusicContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"一无所有";
    message.description = @"崔健";
    [message setThumbImage:[UIImage imageNamed:@"res3.jpg"]];
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = @"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4B880E697A0E68980E69C89222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696334382E74632E71712E636F6D2F586B30305156342F4141414130414141414E5430577532394D7A59344D7A63774D4C6735586A4C517747335A50676F47443864704151526643473444442F4E653765776B617A733D2F31303130333334372E6D34613F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D30222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31342E71716D757369632E71712E636F6D2F33303130333334372E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E4B880E697A0E68980E69C89222C22736F6E675F4944223A3130333334372C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E5B494E581A5222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D313574414141416A41414141477A4C36445039536A457A525467304E7A38774E446E752B6473483833344843756B5041576B6D48316C4A434E626F4D34394E4E7A754450444A647A7A45304F513D3D2F33303130333334372E6D70333F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D3026616D703B73747265616D5F706F733D35227D";
    ext.musicDataUrl = @"http://stream20.qqmusic.qq.com/32464723.mp3";
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

-(void) sendVideoContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"乔布斯访谈";
    message.description = @"饿着肚皮，傻逼着。";
    [message setThumbImage:[UIImage imageNamed:@"res7.jpg"]];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = @"http://v.youku.com/v_show/id_XNTUxNDY1NDY4.html";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespVideoContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"楚门的世界";
    message.description = @"一样的监牢，不一样的门";
    [message setThumbImage:[UIImage imageNamed:@"res4.jpg"]];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = @"http://video.sina.com.cn/v/b/65203474-2472729284.html";
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

#define BUFFER_SIZE 1024 * 100
- (void) sendAppContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"App消息";
    message.description = @"这种消息只有App自己才能理解，由App指定打开方式！";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    message.messageExt = @"这是第三方带的测试字段";
    message.messageAction = @"<action>dotaliTest</action>";
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = @"http://weixin.qq.com";
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespAppContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"App消息";
    message.description = @"这种消息只有App自己才能理解，由App指定打开方式！";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    message.messageExt = @"这是第三方带的测试字段";
    message.messageAction = @"<action>dotaliTest</action>";
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = @"http://weixin.qq.com";
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) sendNonGifContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5" ofType:@"jpg"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)RespNonGifContent{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5" ofType:@"jpg"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) sendGifContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res6thumb.png"]];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6" ofType:@"gif"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)RespGifContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res6thumb.png"]];
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6" ofType:@"gif"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) RespEmoticonContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5" ofType:@"jpg"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void)sendAuthRequest
{
    // 查看是否需要刷新TOKEN
    NSString* tokenInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenInfo"];
    if (tokenInfo != nil) {
        long nowTimeStamp = [[NSDate date] timeIntervalSince1970];
        NSString* lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"getTokenTime"];
        long lastTimeStamp =[lastTime longLongValue];

        // 把授权信息从JSON转成DICTIONARY
        SBJSON *json = [[SBJSON new] autorelease];
        self.tokenDict = (NSDictionary*)[json objectWithString:tokenInfo error:nil];
        long rate = nowTimeStamp - lastTimeStamp;
        if (rate < [[self.tokenDict objectForKey:@"expires_in"] longValue] - 1200) {
            [self getUserInfo];
            [self callServer];
            return;
        }
    }
    
    
    SendAuthReq* req = [[[SendAuthReq alloc] init] autorelease];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    req.state = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
    //req.openID = @"0c806938e2413ce73eef92cc3";
    
    [WXApi sendAuthReq:req viewController:self.viewController delegate:self];
}

- (void)sendFileContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"iphone4.pdf";
    message.description = @"Pro CoreData";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"pdf";
  //  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CoreData" ofType:@"pdf"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"iphone4" ofType:@"pdf"];
    ext.fileData = [NSData dataWithContentsOfFile:filePath];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) testUrlLength : (NSString*) length
{
    if (length == nil) {
        length = @"0";
    }
    
    NSMutableString* flatStr = [[[NSMutableString alloc] init] autorelease];
    for (int i = 0; i<1024; i++) {
        [flatStr appendFormat:@"%d",1];
    }
    NSMutableString* str = [[[NSMutableString alloc] init] autorelease];
    for (int i=0; i<length.intValue; i++) {
        [str appendFormat:@"%@",flatStr];
    }
    [str appendFormat:@"%@",@"test"];
    NSString* url = [NSString stringWithFormat:@"weixin://%@",str];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)RespFileContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"ML.pdf";
    message.description = @"机器学习与人工智能学习资源导引";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"pdf";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ML" ofType:@"pdf"];
    ext.fileData = [NSData dataWithContentsOfFile:filePath];

    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void)openProfile
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入appid" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 2000;
    [alertView textFieldAtIndex:0].text = @"gh_877fdb038ace";
    [alertView show];
    [alertView release];
}

- (void)jumpToBizWebview
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入appid" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 4000;
    [alertView textFieldAtIndex:0].text = @"wxae3e8056daea8727";
    [alertView show];
    [alertView release];
}

- (void) batchAddCardToWXCardPackage
{
    AddCardToWXCardPackageReq *req = [[[AddCardToWXCardPackageReq alloc]init]autorelease];
    NSMutableArray* ary = [NSMutableArray array];
    WXCardItem* item = [[[WXCardItem alloc] init] autorelease];
    item.cardId = @"po_2Djks4-yP5PGtgGY4GkbAIIt0";
    [ary addObject:item];
    
    WXCardItem* item1 = [[[WXCardItem alloc] init] autorelease];
    item1.cardId = @"po_2Djks4-yP5PGtgGY4GkbAIIt0";
    [ary addObject:item1];
    
    WXCardItem* item2 = [[[WXCardItem alloc] init] autorelease];
    item2.cardId = @"po_2DjtUhT_i8Q5Hgc0HLkCegYc8";
    [ary addObject:item2];
    
    req.cardAry = ary;
    [WXApi sendReq:req];
}

- (void)addCardToWXCardPackage
{
    AddCardToWXCardPackageReq *req = [[[AddCardToWXCardPackageReq alloc]init]autorelease];
    NSMutableArray* ary = [NSMutableArray array];
    WXCardItem* item = [[[WXCardItem alloc] init] autorelease];
    item.cardId = @"pbLatjud4zKvxcCnYCh_7oUhKlMs";
    [ary addObject:item];
    
    req.cardAry = ary;
    [WXApi sendReq:req];
}

- (NSDictionary*) parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        [params setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
    }
    return params;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

// 通过CODE获取TOKEN_CODE和OPENID
-(void)getTokenByCode:(NSString*)code {
    NSString* url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", APPID, APPSECRET, code];
    NSString* result = [[HttpCom instance] sendHttpSyncRequest:url];
    // 保存TOKENINFO到本地
    [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"tokenInfo"];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    [[NSUserDefaults standardUserDefaults] setObject:timeSp forKey:@"getTokenTime"];
    
    // 把授权信息从JSON转成DICTIONARY
    SBJSON *json = [[SBJSON new] autorelease];
    self.tokenDict = (NSDictionary*)[json objectWithString:result error:nil];
    
}

// 通过CODE和OPENID获取
-(void)getUserInfo{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", [self.tokenDict objectForKey:@"access_token"], [self.tokenDict objectForKey:@"openid"]];
   
    NSString* result = [[HttpCom instance] sendHttpSyncRequest:url];
    
    // 把用户信息从JSON转成DICTIONARY
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary* userInfoDict = (NSDictionary*)[json objectWithString:result error:nil];;
    self.userInfoDict = userInfoDict;
}

-(void)callServer {
    
    NSString * url = [NSString stringWithFormat:@"http://cgzs.py3d.cn/index.php?g=Wap&m=Py3dcgzs&a=index&openid=%@&headimgurl=%@&app=true", [self.userInfoDict objectForKey:@"openid"], [self.userInfoDict objectForKey:@"headimgurl"]];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [((SendMsgToWeChatViewController*)self.viewController).webView loadRequest:request];
}


@end

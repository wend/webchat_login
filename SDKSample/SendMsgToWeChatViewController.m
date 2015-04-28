//
//  SendMsgToWeChatViewController.m
//  ApiClient
//
//  Created by Tencent on 12-2-27.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import "SendMsgToWeChatViewController.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define TIPSLABEL_TAG 10086

@implementation SendMsgToWeChatViewController

@synthesize delegate = _delegate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)onSelectSessionScene{
    [_delegate changeScene:WXSceneSession];
    
    UILabel *tips = (UILabel *)[self.view viewWithTag:TIPSLABEL_TAG];
    tips.text = @"分享场景:会话";
}

- (void)onSelectTimelineScene{
    [_delegate changeScene:WXSceneTimeline];
    
    UILabel *tips = (UILabel *)[self.view viewWithTag:TIPSLABEL_TAG];
    tips.text = @"分享场景:朋友圈";
}

- (void)onSelectFavoriteScene{
    [_delegate changeScene:WXSceneFavorite];
    
    UILabel *tips = (UILabel *)[self.view viewWithTag:TIPSLABEL_TAG];
    tips.text = @"分享场景:收藏";
}

- (void)sendTextContent
{
    if (_delegate) {
        [_delegate sendTextContent];
    }
}

- (void)sendImageContent
{
    if (_delegate)
    {
        [_delegate sendImageContent];
    }
}

- (void)sendLinkContent
{
    if (_delegate)
    {
        [_delegate sendLinkContent];
    }
}

- (void)sendMusicContent
{
    if (_delegate)
    {
        [_delegate sendMusicContent];
    }
}

- (void)sendVideoContent
{
    if (_delegate)
    {
        [_delegate sendVideoContent];
    }
}

- (void)sendAppContent
{
    if (_delegate)
    {
        [_delegate sendAppContent];
    }
}

- (void)sendNonGifContent
{
    if (_delegate) {
        [_delegate sendNonGifContent];
    }
}

- (void)sendGifContent{
    if (_delegate) {
        [_delegate sendGifContent];
    }
}

- (void)sendAuthRequest
{
    if (_delegate)
    {
        [_delegate sendAuthRequest];
    }
}

- (void)sendFileContent
{
    if (_delegate) {
        [_delegate sendFileContent];
    }
}

- (void)testUrlLength
{
    if (_delegate) {
        UITextView* textView = (UITextView*)[self.view viewWithTag:10001];
        [_delegate testUrlLength:textView.text];
    }
}

- (void)openProfile
{
    if (_delegate) {
        [_delegate openProfile];
    }
}

- (void)jumpToBizWebview
{
    if (_delegate) {
        [_delegate jumpToBizWebview];
    }
}

- (void)addCardToWXCardPackage{
    if (_delegate) {
        [_delegate addCardToWXCardPackage];
    }
}

- (void)batchAddCardToWXCardPackage
{
    if (_delegate) {
        [_delegate batchAddCardToWXCardPackage];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int width = [[UIScreen mainScreen] bounds].size.width;
    int height = [[UIScreen mainScreen] bounds].size.height;
    
    UIWebView* webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)] autorelease];
    [self.view addSubview:webView];
    webView.delegate = self;
    
    self.webView = webView;
    
    /*UIScrollView *footView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, 40)];
    [footView setBackgroundColor:RGBCOLOR(0xef, 0xef, 0xef)];
    footView.contentSize = CGSizeMake(width, height);
    
    UIButton *btn9 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn9 setTitle:@"微信授权登录" forState:UIControlStateNormal];
    btn9.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn9 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn9 setFrame:CGRectMake(0, 20, 145, 20)];
    [btn9 addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn9];

    
    [self.view addSubview:footView];
    [footView release];*/
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.delegate sendAuthRequest];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView*)textView {
	[textView becomeFirstResponder];
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView*)textView {
	[textView resignFirstResponder];
	return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    return YES;   
    
}

- (void)dealloc
{
    [super dealloc];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"should start load with request:%@", request);
    return true;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish load");
}

@end

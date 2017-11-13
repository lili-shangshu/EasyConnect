//
//  SPWebController.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/10.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "SPWebController.h"
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>

@interface SPWebController () <UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic, strong) UIWebView *webview;

@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@end

@implementation SPWebController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // WebView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    webView.scalesPageToFit = YES;
    webView.height = self.view.height - kTransulatInset;
    webView.scrollView.scrollEnabled = YES;
    [self.view addSubview:webView];
    self.webview = webView;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
//    [[FGNetworkManager sharedClient] getGoodsDetailsWithUUID:self.goodsObject.uuid completion:^(BOOL success, id data, NSError *error){
//        if (success && [data checkObjectForKey:kFGGoods_Info] && data[kFGGoods_Info]) {
//            [webView loadHTMLString:data[kFGGoods_Info] baseURL:nil];
//        }
//    }];
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    [_progressView setProgress:0 animated:NO];
    _progressView.top = 64.f;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_progressView];
    
    if (!self.hideShareButton) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"分享" titleColor:[UIColor whiteColor] target:self action:@selector(shareButtonAction:)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (self.urlString) {
//        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
//    }else {
//        [self.webview loadHTMLString:self.htmlString baseURL:nil];
//    }
    [self showWifiErrorView:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *cookies = [storage cookiesForURL:self.webview.request.URL];
//    for (cookie in cookies) [storage deleteCookie:cookie];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Action
////////////////////////////////////////////////////////////////////////////////////

- (void)shareButtonAction:(id)sender
{
    [NAShareManager shareManager].item = self.item;
    [NAShareManager showFlyGiftShareSheet];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NJKWebViewProgressDelegate
////////////////////////////////////////////////////////////////////////////////////

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

@end

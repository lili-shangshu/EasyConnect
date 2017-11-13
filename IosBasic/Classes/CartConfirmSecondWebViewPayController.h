//
//  CartConfirmSecondWebViewPayController.m
//  IosBasic
//
//  Created by junshi on 2017/5/10.
//  Copyright © 2017年 CRZ. All rights reserved.
//

//
//  JBWebViewController.h
//  JBWebViewController
//
//  Created by Jonas Boserup on 28/10/14.
//  Copyright (c) 2014 Jonas Boserup. All rights reserved.
//

// Required Apple libraries
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "NARootController.h"

// Required third-party libraries
#import <ARChromeActivity/ARChromeActivity.h>
#import <ARSafariActivity/ARSafariActivity.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <NJKWebViewProgress/NJKWebViewProgressView.h>
#import <JavaScriptCore/JavaScriptCore.h>


@protocol NAWebControllerDelegate <NSObject>

- (void)showReturn;

@end

@interface CartConfirmSecondWebViewPayController : NARootController <UIWebViewDelegate, NJKWebViewProgressDelegate>

@property(weak,nonatomic)id<NAWebControllerDelegate>delegate;

// Typedef for completion block
typedef void (^completion)(CartConfirmSecondWebViewPayController *controller);
@property (strong, nonatomic) JSContext *context;
// Loding string
@property (nonatomic, strong) NSString *loadingString;

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) UIWebView *webView;


@property (nonatomic, assign) BOOL hideShareButton;
@property (nonatomic, assign) BOOL hideExitButton;

@property (nonatomic, strong) NSString *webTitleString;
@property (nonatomic, strong) NSString *defautlTitleString;

@property (nonatomic, assign) BOOL isHideNav;
@property (nonatomic, assign) BOOL isshowBack;

@property(strong,nonatomic) NSString *orderId;
@property(strong,nonatomic) ECAddress * selectAddress ; // 需要在第三个页面显示出来
@property(nonatomic,strong)NSMutableArray *buttonArray;


// Public header methods
- (id)initWithUrl:(NSURL *)url;
- (void)show;
- (void)showFromController:(UIViewController*)controller;
- (void)dismiss;
- (void)reload;
- (void)share;
- (void)setWebTitle:(NSString *)title;
- (void)setWebSubtitle:(NSString *)subtitle;
- (void)showControllerWithCompletion:(completion)completion;
- (void)showFromController:(UIViewController*)controller WithCompletion:(completion)completion;
- (void)navigateToURL:(NSURL *)url;
- (void)loadRequest:(NSURLRequest *)request;

// Public return methods
- (NSString *)getWebTitle;
- (NSString *)getWebSubtitle;

@end


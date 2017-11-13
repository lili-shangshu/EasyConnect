//
//  JBWebViewController.m
//  JBWebViewController
//
//  Created by Jonas Boserup on 28/10/14.
//  Copyright (c) 2014 Jonas Boserup. All rights reserved.
//

#import "NAWebController.h"
#import <Reachability.h>


@interface  NAWebController ()

// Private properties
@property (nonatomic, strong) NSURL *url;
@property (nonatomic) BOOL hasExtraButtons;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) UIPopoverController *popoverShareController;

@end

@implementation NAWebController

#pragma mark - "Standards"

- (id)initWithUrl:(NSURL *)url {
    // Set url and init views
    _url = url;
    [self setup];
    
    // Return self
    return self;
}

- (void)viewDidLoad {
    // Standard super class stuff
    [super viewDidLoad];
    
    self.wifiTestTriger = YES;
    self.wifiErrerTip = @"网络异常";
    self.tipView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    // Standard super class stuff
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Standard super class stuff
    // Add NJKWebViewProgressView to UINavigationBar
    if (!_progressView) {
        //        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - 2, self.navigationController.navigationBar.frame.size.width, 2)];
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 2)];
        _progressView.progressBarView.backgroundColor = [UIColor spDeleteButtonColor];
        [_progressView setProgress:0];
        //        [self.navigationController.navigationBar addSubview:_progressView];
        [self.view addSubview:_progressView];
    }
    _progressView.hidden = NO;
    
    if (self.hideShareButton) {
        self.navigationItem.rightBarButtonItems = nil;
    }
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Standard super class stuff
    [super viewWillDisappear:animated];
    
    // Remove views
    _progressView.hidden = YES;
    [_titleView removeFromSuperview];
    
    if (self.defautlTitleString) {
        self.title = self.defautlTitleString;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Will adjust views in UINavigationBar upon changed interface orientation
    [self adjustNavigationbar];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Update progressBar location
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    [_progressView setFrame:barFrame];
}

#pragma mark - "Setup"

- (void)setup {
    // Default value
    _hasExtraButtons = NO;
    
    // Allows navigationbar to overlap webview
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
//    // Create title & subtitle labels
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [_titleLabel setBackgroundColor:[UIColor clearColor]];
//    [_titleLabel setTextColor:[UIColor blackColor]];
//    [_titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
//    [_titleLabel setTextAlignment:NSTextAlignmentNatural];
//    [_titleLabel setText:_loadingString];
//    [_titleLabel sizeToFit];
//    
//    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 0, 0)];
//    [_subtitleLabel setBackgroundColor:[UIColor clearColor]];
//    [_subtitleLabel setTextColor:[UIColor blackColor]];
//    [_subtitleLabel setFont:[UIFont systemFontOfSize:12]];
//    [_subtitleLabel setTextAlignment:NSTextAlignmentLeft];
//    [_subtitleLabel setText:[self getDomainFromString:[NSString stringWithFormat:@"%@", _url]]];
//    [_subtitleLabel sizeToFit];
//    
//    // Correct frame sizes after sizeToFit
//    [self adjustNavigationbar];
//    
//    // Add new titleview with labels
//    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//    [_titleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//    
//    [_titleView addSubview:_titleLabel];
//    [_titleView addSubview:_subtitleLabel];
//    
//    self.navigationItem.titleView = _titleView;
    
    // Inset right buttons
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
//    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Dismiss"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:dismissButton, shareButton, nil]];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"" titleColor: target:<#(id)#> action:<#(SEL)#>]
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"Share" titleColor:[UIColor whiteColor] target:self action:@selector(shareButtonAction:)];
    
    
    // Add a webview
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [_webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    [self.view addSubview:_webView];
    
    // Configureing NJKWebViewProgress
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
//    CGFloat progressBarHeight = 2.f;
//    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
//    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
//    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    _progressView.backgroundColor = [UIColor whiteColor]
//    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    
//    CGFloat progressBarHeight = 2.f;
//    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
//    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
//    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    //    [_progressView setProgress:0 animated:NO];
//    _progressView.top = 64.f;
//    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    [self.view addSubview:_progressView];
    
    // Navigating to URL
    [self navigateToURL:_url];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Action
////////////////////////////////////////////////////////////////////////////////////



#pragma mark - "Showing controller"

- (void)show {
    // Showing controller with no completion void
    [self showControllerWithCompletion:nil];
}

- (void)showFromController:(UIViewController*)controller
{
    [self showFromController:controller WithCompletion:nil];
    
}

- (void)showControllerWithCompletion:(completion)completion {
    // Creates navigation controller, and presents it
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    
    // Using modalViewController completion void
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:navigationController animated:YES completion:^{
        // Send completion callback
        if (completion) {
            completion(self);
        }
    }];
}
- (void)showFromController:(UIViewController*)controller WithCompletion:(completion)completion
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    [controller presentViewController:navigationController animated:YES completion:^{
        if (completion) {
            completion(self);
        }
    }];
}

#pragma mark - "Navigation"

- (void)navigateToURL:(NSURL *)url {
    // Tell UIWebView to load url
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)reloadingDataAction:(id)sender{

    if (self.wifiTestTriger) {
        if (![[Reachability reachabilityWithHostName:kHomeName] isReachable]) {
            [self showWifiErrorView:YES];
        }else{
            [self showWifiErrorView:NO];
            [self reload];
        }
    }

}

- (void)reload {
    // Tell UIWebView to reload
    [_webView reload];
}

- (void)navigateBack {
    // Tell UIWebView to go back
    [_webView goBack];
}

- (void)navigateForward {
    // Tell UIWebView to go forward
    [_webView goForward];
}

- (void)loadRequest:(NSURLRequest *)request {
    // Tell UIWebView to load request
    [_webView loadRequest:request];
}

#pragma mark - "Right buttons"

- (void)share {
    // Create instances of third-party share actions
    ARSafariActivity *safariActivity = [[ARSafariActivity alloc] init];
    ARChromeActivity *chromeActivity = [[ARChromeActivity alloc] init];
    
    // Create share controller from our url
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[self.webView.request.URL] applicationActivities:@[safariActivity, chromeActivity]];
    
    // If device is iPad
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Dismiss popover if present
        if(_popoverShareController) {
            [_popoverShareController dismissPopoverAnimated:YES];
        }
        
        // Insert share controller in popover and present it
        _popoverShareController = [[UIPopoverController alloc] initWithContentViewController:controller];
        [_popoverShareController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItems[1] permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
    } else {
        // Present share sheet (on iPhone)
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        // Code
    }];
}

#pragma mark - "Navigationbar"

- (void)adjustNavigationbar {
    // Width of buttons in UINavigationBar
    float buttonsWidth;
    
    if(_hasExtraButtons) {
        buttonsWidth = 220;
    } else {
        buttonsWidth = 110;
    }
    
    // Setting frames on title & subtitle labels
//    [_titleLabel setFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, MIN(_titleLabel.frame.size.width, self.view.frame.size.width - buttonsWidth), _titleLabel.frame.size.height)];
//    [_subtitleLabel setFrame:CGRectMake(_subtitleLabel.frame.origin.x, _subtitleLabel.frame.origin.y, MIN(_subtitleLabel.frame.size.width, self.view.frame.size.width - buttonsWidth), _subtitleLabel.frame.size.height)];
}

- (void)addNavigationButtonsButtons {
    // Creating buttons
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(navigateBack)];
    UIBarButtonItem *backButton = [UIBarButtonItem NA_BarButtonWithImage:[[UIImage imageNamed:@"spBack"] imageWithColor:[UIColor whiteColor]] titile:@"返回" fontSize:17.f leftOffSet:-15.f backImg:nil target:self action:@selector(navigateBack)];
    UIBarButtonItem *closeButton = [UIBarButtonItem NA_BarButtonWithtitile:@"关闭" titleColor:[UIColor whiteColor] target:self action:@selector(closeButtonAction:)];
    
    // Adding buttons to NavigationBar
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:backButton, closeButton, nil]];
    
    // Remember that we have extra buttons now
    _hasExtraButtons = YES;
    
    // And finally adjust NavigationBar
    [self adjustNavigationbar];
}

- (void)updateNavigationButtons {
    // If no left buttons are present and webView can go back, then add buttons
    if(!self.navigationItem.leftBarButtonItems.count && [_webView canGoBack]) {
        [self addNavigationButtonsButtons];
    }
    
    
    if (![_webView canGoBack]) {
        [self.navigationItem setLeftBarButtonItems:nil];
    }
    
    // If we can go back, enable back button
//    if([_webView canGoBack]) {
//        ((UIBarButtonItem *)self.navigationItem.leftBarButtonItems[0]).enabled = YES;
//    } else {
//        ((UIBarButtonItem *)self.navigationItem.leftBarButtonItems[0]).enabled = NO;
//    }
//    
//    // If we can go forward, enable forward button
//    if([_webView canGoForward]) {
//        ((UIBarButtonItem *)self.navigationItem.leftBarButtonItems[1]).enabled = YES;
//    } else {
//        ((UIBarButtonItem *)self.navigationItem.leftBarButtonItems[1]).enabled = NO;
//    }
}

- (void)closeButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - "Titles & subtitles"

- (void)setWebTitle:(NSString *)title {
    // Set title & update frame
//    [_titleLabel setText:title];
//    [_titleLabel sizeToFit];
//    [self adjustNavigationbar];
    if (self.defautlTitleString) {
        self.title = self.defautlTitleString;
    }else
        self.title = title;
    
    if (![self.webView canGoBack] && self.webTitleString) {
        self.title = self.webTitleString;
    }
}

- (void)setWebSubtitle:(NSString *)subtitle {
    // Set subtitle & update frame
//    [_subtitleLabel setText:subtitle];
//    [_subtitleLabel sizeToFit];
//    [self adjustNavigationbar];
}

// Get title
- (NSString *)getWebTitle {
    return self.title;
}

// Get subtitle
- (NSString *)getWebSubtitle {
    return _subtitleLabel.text;
}

#pragma mark - "Helpers"

- (NSString *)getDomainFromString:(NSString*)string
{
    // Split url into components
    NSArray *components = [string componentsSeparatedByString:@"/"];
    for (NSString *match in components) {
        // If component has range of ".", return match
        if ([match rangeOfString:@"."].location != NSNotFound){
            return match;
        }
    }
    return nil;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Update title when page is loaded
    NSString *title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    NSString *subtitle = [webView stringByEvaluatingJavaScriptFromString:@"document.domain"];
    
    if ([title isEmptyString] && ![self.webTitleString isEmptyString]) {
        [self setWebTitle:self.webTitleString];
    }else
        [self setWebTitle:title];
    [self setWebSubtitle:subtitle];
    [self updateNavigationButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Log error
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    // Update NJKWebViewProgressView
    [_progressView setProgress:progress animated:YES];
    NALog(@"-----> progress : %f",progress);
    
    // Update title
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    
    // If no title is found, set it to "Loading.."
    if(title.length == 0) {
        [self setWebTitle:_loadingString];
    } else {
        [self setWebTitle:title];
    }
}

@end
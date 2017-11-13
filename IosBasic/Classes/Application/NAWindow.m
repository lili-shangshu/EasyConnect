//
//  FGWindow.m
//  FlyGift
//
//  Created by Nathan Ou on 15/1/30.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NAWindow.h"

@interface NAWindow () <SKSplashDelegate>

@end

@implementation NAWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self launchSlpash];
    }
    return self;
}


#pragma mark - Custom Load Example

- (void) customLoadSplash
{
    //Adding splash view
    UIColor *customColor = [UIColor colorWithRed:168.0f/255.0f green:36.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    _splashView = [[SKSplashView alloc] initWithBackgroundColor:customColor animationType:SKSplashAnimationTypeZoom];
    _splashView.animationDuration = 3.0f;
    _splashView.delegate = self;
    //Adding activity indicator view on splash view
    //    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //    _indicatorView.frame = self.view.frame;
    [self addSubview:_splashView];
    //    [self.view addSubview:_indicatorView];
    [_splashView startAnimation];
}

#pragma mark - Twitter Example

- (void)launchSlpash
{
    //Twitter style splash
    
    UIImage *launchImage;
    if (IS_IPHONE5) {
        launchImage = [UIImage imageNamed:@"LaunchImage-700-568h"];
    }else if (IS_IPHONE6) {
        launchImage = [UIImage imageNamed:@"LaunchImage-800-667h"];
    }else if (IS_IPHONE6_PLUS) {
        launchImage = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
    }else {
        launchImage = [UIImage imageNamed:@"LaunchImage-700"];
    }
    _splashView = [[SKSplashView alloc] initWithBackgroundImage:launchImage animationType:SKSplashAnimationTypeFade];
    _splashView.delegate = self; //Optional -> if you want to receive updates on animation beginning/end
    _splashView.animationDuration = 1.5f; //Optional -> set animation duration. Default: 1s
    [self addSubview:_splashView];
    [_splashView startAnimation];
}

#pragma mark - Delegate methods

- (void)splashView:(SKSplashView *)splashView didBeginAnimatingWithDuration:(float)duration
{
    NSLog(@"Started animating from delegate");
    //To start activity animation when splash animation starts
    //    [_indicatorView startAnimating];
}

- (void)splashViewDidEndAnimating:(SKSplashView *)splashView
{
    NSLog(@"Stopped animating from delegate");
    //To stop activity animation when splash animation ends
    //    [_indicatorView stopAnimating];
    
    
}

@end

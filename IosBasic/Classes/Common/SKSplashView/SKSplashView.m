//
//  SKSplashView.m
//  SKSplashView
//
//  Created by Sachin Kesiraju on 10/25/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import "SKSplashView.h"
#import "SKSplashIcon.h"

@interface SKSplashView()

@property (nonatomic, assign) SKSplashAnimationType animationType;
@property (nonatomic, assign) SKSplashIcon *splashIcon;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong)UILabel *titlelable;
@property(nonatomic) CGFloat number;
@property (strong, nonatomic) CAAnimation *customAnimation;

@end

@implementation SKSplashView

#pragma mark - Instance methods

- (instancetype)initWithAnimationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _animationType = animationType;
    }
    
    return self;
}

- (instancetype) initWithBackgroundColor:(UIColor *)backgroundColor animationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _backgroundViewColor = backgroundColor;
        self.backgroundColor = [self setBackgroundViewColor];
        _animationType = animationType;
    }
    
    return self;
}

- (instancetype) initWithBackgroundImage:(UIImage *)backgroundImage animationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _backgroundImage = backgroundImage;
        _animationType = animationType;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
    }
    // 划线
    [self drawLine];
    
    return self;
}

- (instancetype) initWithSplashIcon:(SKSplashIcon *)icon animationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _splashIcon = icon;
        _animationType = animationType;
        self.backgroundColor = [self setBackgroundViewColor];
        icon.center = self.center;
        [self addSubview:icon];
    }
    
    return self;
}

- (instancetype) initWithSplashIcon:(SKSplashIcon *)icon backgroundColor:(UIColor *)backgroundColor animationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _splashIcon = icon;
        _backgroundViewColor = backgroundColor;
        _animationType = animationType;
        icon.center = self.center;
        self.backgroundColor = _backgroundViewColor;
        [self addSubview:icon];
    }
    return self;
}

- (instancetype) initWithSplashIcon:(SKSplashIcon *)icon backgroundImage:(UIImage *)backgroundImage animationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _splashIcon = icon;
        _backgroundImage = backgroundImage;
        _animationType = animationType;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        [self addSubview:icon];
    }
    return self;
}

#pragma mark - Public methods

- (void)drawLine{
    UILabel *loadLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, NAScreenHeight/2-20, NAScreenWidth, 40)];
    [loadLbl setLabelWith:@"Loading" color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:20] aliment:NSTextAlignmentCenter];
    self.titlelable  =loadLbl;
    [self addSubview:loadLbl];
    self.number = 0;
    self.backgroundColor = [UIColor colorWithHexString:@"#1a7bc0"];
    
}

- (void)startAnimation;

{
    //间隔时间
    CGFloat timee= 3.0/8;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timee target:self selector:
                  @selector(circleAnimation) userInfo:nil repeats:YES];
    
    if(_splashIcon)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f",self.animationDuration] forKey:@"animationDuration"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startAnimation" object:self userInfo:dic];
    }
    if([self.delegate respondsToSelector:@selector(splashView:didBeginAnimatingWithDuration:)])
    {
        [self.delegate splashView:self didBeginAnimatingWithDuration:self.animationDuration];
    }
    
    switch(_animationType)
    {
        case SKSplashAnimationTypeBounce:
            [self addBounceAnimation];
            break;
        case SKSplashAnimationTypeFade:
//            [self addFadeAnimation];
            break;
        case SKSplashAnimationTypeZoom:
            [self addZoomAnimation];
            break;
        case SKSplashAnimationTypeShrink:
            [self addShrinkAnimation];
            break;
        case SKSplashAnimationTypeNone:
            [self addNoAnimation];
            break;
        case SKSplashAnimationTypeCustom:
            if(_animationType)
            {
                [self addCustomAnimationWithAnimation:_customAnimation];
            }
            else
            {
//                [self addCustomAnimationWithAnimation:[self customAnimation]];
            }
            break;
        default:NSLog(@"No animation type selected");
            break;
    }
}

//定时器每次时间到了执行
- (void)circleAnimation{
   
    NSLog(@"======%.1f",self.number);
    self.number += 1;
    NSString *lableStr = @"Loading";
    if(self.number==1){
         lableStr=@"Loading.";
    }else if (self.number==2){
        lableStr=@"Loading..";
    }else if (self.number==3){
        lableStr=@"Loading...";
    }else{
        //停止计时器
        lableStr=@"Loading...";
        [self.timer invalidate];
        self.timer = nil;
        [self removeFromSuperview];
        [self endAnimating];
    }
    self.titlelable.text = lableStr;
    
}


- (void) setCustomAnimationType:(CAAnimation *)animation
{
    _customAnimation = animation;
}

- (void) setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    imageView.frame = [UIScreen mainScreen].bounds;
    [self addSubview:imageView];
}

#pragma mark - Property setters

- (CGFloat)animationDuration
{
    if (!_animationDuration) {
        _animationDuration = 1.0f;
    }
    return _animationDuration;
}

- (CAAnimation *)customAnimation
{
    if (!_animationType) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@1, @0.9, @300];
        animation.keyTimes = @[@0, @0.4, @1];
        animation.duration = self.animationDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        _customAnimation = animation;
    }
    return _customAnimation;
}

- (UIColor *) setBackgroundViewColor
{
    if (!_backgroundViewColor) {
        _backgroundViewColor = [UIColor whiteColor];
    }
    return _backgroundViewColor;
}

#pragma mark - Animations

- (void) addBounceAnimation
{
    CGFloat bounceDuration = self.animationDuration * 0.8;
    [NSTimer scheduledTimerWithTimeInterval:bounceDuration target:self selector:@selector(pingGrowAnimation) userInfo:nil repeats:NO];
}

- (void) pingGrowAnimation
{
    CGFloat growDuration = self.animationDuration *0.2;
    [UIView animateWithDuration:growDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
        self.transform = scaleTransform;
        self.alpha = 0;
        self.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self endAnimating];
    }];
}

- (void) growAnimation
{
    CGFloat growDuration = self.animationDuration * 0.7;
    [UIView animateWithDuration:growDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
        self.transform = scaleTransform;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self endAnimating];
    }];
}

- (void) addFadeAnimation
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self endAnimating];
    }];
}

- (void) addShrinkAnimation
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.5, 0.5);
        self.transform = scaleTransform;
        self.alpha = 0;
    }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
         [self endAnimating];
     }];
}

- (void) addZoomAnimation
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(10, 10);
        self.transform = scaleTransform;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self endAnimating];
    }];
}

- (void) addNoAnimation
{
    [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(removeSplashView) userInfo:nil repeats:NO];
}

- (void) addCustomAnimationWithAnimation: (CAAnimation *) animation
{
    [self.layer addAnimation:animation forKey:@"SKSplashAnimation"];
    [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(removeSplashView) userInfo:nil repeats:YES];
}

- (void) removeSplashView
{
    [self removeFromSuperview];
    [self endAnimating];
}

- (void) endAnimating
{
    if([self.delegate respondsToSelector:@selector(splashViewDidEndAnimating:)])
    {
        [self.delegate splashViewDidEndAnimating:self];
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

//
//  FGPhotoToolSheet.m
//  FlyGift
//
//  Created by Nathan Ou on 14/12/30.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import "FGToolSheet.h"
#import "FGOperationButton.h"

@interface FGToolSheet ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) FGOperationButton *leftButton;
@property (nonatomic, strong) FGOperationButton *rightButton;

@property (nonatomic, strong) void(^leftButtonActionBlock)();
@property (nonatomic, strong) void(^rightButtonActionBlock)();

@end

@implementation FGToolSheet

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = [FGToolSheet keyWindow].bounds;
    }
    return self;
}

+ (UIWindow *)keyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor grayColor];
        _backgroundView.alpha = 0.2f;
        [self addSubview:_backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonAction)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (FGOperationButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[FGOperationButton alloc] initWithTitle:@"Take Pics" titleFont:[UIFont defaultTextFontWithSize:17.f] images:@[[UIImage imageNamed:@"camera"]]];
        [_leftButton addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setTitleFont:[UIFont defaultTextFontWithSize:17.f] color:[UIColor blackColor]];
    }
    return _leftButton;
}

- (FGOperationButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[FGOperationButton alloc] initWithTitle:@"Take Pics" titleFont:[UIFont defaultTextFontWithSize:17.f] images:@[[UIImage imageNamed:@"camera"]]];
        [_rightButton addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitleFont:[UIFont defaultTextFontWithSize:17.f] color:[UIColor blackColor]];
    }
    return _rightButton;
}

- (UIView *)contentView
{
    if (!_contentView) {
        UIWindow *window = [FGToolSheet keyWindow];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, window.height, window.width, 200)];
        _contentView.backgroundColor = [UIColor clearColor];
        
        UIView *groundView = [[UIView alloc] initWithFrame:_contentView.bounds];
        groundView.backgroundColor = [UIColor whiteColor];
      //  groundView.alpha = 0.85f;
        [_contentView addSubview:groundView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.backgroundColor = [UIColor clearColor];
        cancelButton.frame = CGRectMake(0, _contentView.height-65.f, _contentView.width, 65.f);
        [cancelButton setTitleColor:[UIColor cancelButton] forState:UIControlStateNormal];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:cancelButton];
        
        CGFloat paddingHeight = 50.f;
        _contentView.height = cancelButton.height+self.leftButton.height+paddingHeight; // 设置contentView高度
        cancelButton.top = _contentView.height - cancelButton.height;
        groundView.height = _contentView.height;
        
        self.leftButton.top = paddingHeight/2.f;
        self.rightButton.top = self.leftButton.top;
        CGFloat horizotalPadding = (_contentView.width-self.leftButton.width-self.rightButton.width)/3.f;
        self.leftButton.left = horizotalPadding;
        self.rightButton.left = self.leftButton.right+horizotalPadding;
        
        [_contentView addSubview:self.leftButton];
        [_contentView addSubview:self.rightButton];
        
        [self addSubview:_contentView];
        
        // Line View
        UIView *lineView = [UIView lineViewWithWidth:_contentView.width-20.f*2 yPoint:cancelButton.top+1.f withColor:[UIColor spLineColor]];
        lineView.left = 20.f;
        [_contentView addSubview:lineView];
    }
    return _contentView;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////////

- (void)setLeftButtonImage:(UIImage *)image title:(NSString *)title action:(void (^)())block
{
    [self.leftButton setButtonImageWithImage:image];
    [self.leftButton setTitleWithString:title];
    self.leftButtonActionBlock = block;
}

- (void)setRightButtonImage:(UIImage *)image title:(NSString *)title action:(void (^)())block
{
    [self.rightButton setButtonImageWithImage:image];
    [self.rightButton setTitleWithString:title];
    self.rightButtonActionBlock = block;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Actions
////////////////////////////////////////////////////////////////////////////////////

- (void)cancelButtonAction
{
    [self hide];
}

- (void)button1Action:(id)sender
{
    [self hide];
    if (self.leftButtonActionBlock) {
        self.leftButtonActionBlock();
    }
}

- (void)button2Action:(id)sender
{
    [self hide];
    if (self.rightButtonActionBlock) {
        self.rightButtonActionBlock();
    }
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////////////////

- (void)show
{
    [self showWithCompletion:nil];
}

- (void)showWithCompletion:(void (^)())block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[FGToolSheet keyWindow] addSubview:self];
        self.backgroundView.hidden = NO;
        self.backgroundView.alpha = 0;
        self.contentView.top = self.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0.2f;
            self.contentView.top = self.height - self.contentView.height;
        } completion:^(BOOL finish){
            if (block) {
                block();
            }
        }];
    });
}

- (void)hide
{
    [self hideWithCompletion:nil];
}

- (void)hideWithCompletion:(void (^)())block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundView.alpha = 0;
            self.contentView.top = self.height;
        } completion:^(BOOL finish){
            if (block) {
                block();
            }
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    });
}

@end

//
//  FGShareSheet.m
//  FlyGift
//
//  Created by Nathan Ou on 15/1/7.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "FGShareSheet.h"
#import "FGOperationButton.h"

@interface FGShareSheet ()<UIActionSheetDelegate>

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) FGOperationButton *button1;
@property (nonatomic, strong) FGOperationButton *button2;
@property (nonatomic, strong) FGOperationButton *button3;
@property (nonatomic, strong) FGOperationButton *button4;
@property (nonatomic, strong) FGOperationButton *button5;
@property (nonatomic, strong) FGOperationButton *button6;
@property (nonatomic, strong) FGOperationButton *button7;

@end

@implementation FGShareSheet

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = [FGShareSheet keyWindow].bounds;
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
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.55f;
        [self addSubview:_backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonAction)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (FGOperationButton *)button1
{
    if (!_button1) {
        _button1 = [[FGOperationButton alloc] initWithTitle:@"WeChat TimeLine" titleFont:[UIFont defaultTextFontWithSize:12.f] images:@[[UIImage imageNamed:@"wechatTime"]]];
        [_button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
        [_button1 setTitleFont:[UIFont defaultTextFontWithSize:12.f] color:[UIColor defaultSubTitleColor]];
    }
    return _button1;
}

- (FGOperationButton *)button2
{
    if (!_button2) {
        _button2 = [[FGOperationButton alloc] initWithTitle:@"QQ空间" titleFont:[UIFont defaultTextFontWithSize:12.f] images:@[[UIImage imageNamed:@"qqZone"]]];
        [_button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
        [_button2 setTitleFont:[UIFont defaultTextFontWithSize:12.f] color:[UIColor defaultSubTitleColor]];
    }
    return _button2;
}

- (FGOperationButton *)button3
{
    if (!_button3) {
        _button3 = [[FGOperationButton alloc] initWithTitle:@"QQ" titleFont:[UIFont defaultTextFontWithSize:12.f] images:@[[UIImage imageNamed:@"qq"]]];
        [_button3 addTarget:self action:@selector(button3Action:) forControlEvents:UIControlEventTouchUpInside];
        [_button3 setTitleFont:[UIFont defaultTextFontWithSize:12.f] color:[UIColor defaultSubTitleColor]];
    }
    return _button3;
}

- (FGOperationButton *)button4
{
    if (!_button4) {
        _button4 = [[FGOperationButton alloc] initWithTitle:@"WechtFriend" titleFont:[UIFont defaultTextFontWithSize:12.f] images:@[[UIImage imageNamed:@"wechat"]]];
        [_button4 addTarget:self action:@selector(button4Action:) forControlEvents:UIControlEventTouchUpInside];
        [_button4 setTitleFont:[UIFont defaultTextFontWithSize:12.f] color:[UIColor defaultSubTitleColor]];
    }
    return _button4;
}

- (FGOperationButton *)button5
{
    if (!_button5) {
        _button5 = [[FGOperationButton alloc] initWithTitle:@"Facebook" titleFont:[UIFont defaultTextFontWithSize:12.f] images:@[[UIImage imageNamed:@"facebook_share"]]];
        [_button5 addTarget:self action:@selector(button5Action:) forControlEvents:UIControlEventTouchUpInside];
        [_button5 setTitleFont:[UIFont defaultTextFontWithSize:12.f] color:[UIColor defaultSubTitleColor]];
    }
    return _button5;
}

- (FGOperationButton *)button6
{
    if (!_button6) {
        _button6 = [[FGOperationButton alloc] initWithTitle:@"Whatsapp" titleFont:[UIFont defaultTextFontWithSize:12.f] images:@[[UIImage imageNamed:@"whatsapp"]]];
        [_button6 addTarget:self action:@selector(button6Action:) forControlEvents:UIControlEventTouchUpInside];
        [_button6 setTitleFont:[UIFont defaultTextFontWithSize:12.f] color:[UIColor defaultSubTitleColor]];
    }
    return _button6;
}

- (FGOperationButton *)button7
{
    if (!_button4) {
        _button4 = [[FGOperationButton alloc] initWithTitle:@"WeChat" titleFont:[UIFont defaultTextFontWithSize:12.f] images:@[[UIImage imageNamed:@"wechat"]]];
        [_button4 addTarget:self action:@selector(button7Action:) forControlEvents:UIControlEventTouchUpInside];
        [_button4 setTitleFont:[UIFont defaultTextFontWithSize:12.f] color:[UIColor defaultSubTitleColor]];
    }
    return _button4;
}



- (UIView *)contentView
{
    if (!_contentView) {
        UIWindow *window = [FGShareSheet keyWindow];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, window.height, window.width, 200)];
        _contentView.backgroundColor = [UIColor clearColor];
        
        UIView *groundView = [[UIView alloc] initWithFrame:_contentView.bounds];
        groundView.backgroundColor = [UIColor whiteColor];
        groundView.alpha = 0.92f;
        [_contentView addSubview:groundView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.backgroundColor = [UIColor whiteColor];
        cancelButton.frame = CGRectMake(0, _contentView.height-44.f, _contentView.width, 44.f);
        [cancelButton setTitleColor:[UIColor cancelButton] forState:UIControlStateNormal];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:cancelButton];
        
        UILabel *topLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 50.f)];
        [topLable setLabelWith:@"Share" color:[UIColor defaultGrayColor] font:[UIFont systemFontOfSize:15.f] aliment:NSTextAlignmentCenter];
        [_contentView addSubview:topLable];
        
        //        UIView *lineView = [UIView lineViewWithWidth:_contentView.width yPoint:topLable.bottom withColor:[UIColor defaultLineColor]];
        //        [_contentView addSubview:lineView];
        
        // ShareBackGround
        UIView *shareBackgournd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 0)];
        shareBackgournd.backgroundColor = [UIColor clearColor];
        
        CGFloat paddingHeight = 50.f;
        shareBackgournd.top = topLable.bottom;
        shareBackgournd.height = self.button1.height+paddingHeight;
        _contentView.height = cancelButton.height+shareBackgournd.height+topLable.height; // 设置contentView高度
        cancelButton.top = _contentView.height - cancelButton.height;
        groundView.height = _contentView.height;
        
        // Share Alpha Background
        UIView *shareAlhaBackground = [[UIView alloc] initWithFrame:shareBackgournd.bounds];
        shareAlhaBackground.backgroundColor = [UIColor defaultlightGrayColor];
        shareAlhaBackground.alpha = 0.5f;
        [shareBackgournd addSubview:shareAlhaBackground];
        
        NSMutableArray *buttonsArray = [NSMutableArray array];
        
        if(self.weChatBothAction){
            [buttonsArray addObject:self.button7];
        }
        
        if (self.weChatAction) {
            [buttonsArray addObject:self.button4];
        }
        
        if (self.timeLineAction) {
            [buttonsArray addObject:self.button1];
        }
        
        if (self.QQAction) {
            [buttonsArray addObject:self.button3];
        }
        
        if (self.qZoneAction) {
            [buttonsArray addObject:self.button2];
        }
        
        if (self.facebookAction){
            [buttonsArray addObject:self.button5];
        }
        
        if (self.whatsappAction){
            [buttonsArray addObject:self.button6];
        }
        
        
        CGFloat buttonWidth = 0.0;
        for(FGOperationButton *button in buttonsArray)
        {
            buttonWidth = button.width+buttonWidth;
        }
        
        CGFloat padding = (_contentView.width - buttonWidth)/(buttonsArray.count+1);
        CGFloat buttonx = 0;
        for (FGOperationButton *button in buttonsArray) {
            buttonx = buttonx + padding;
            button.left = buttonx;
            buttonx = buttonx+button.width;
            button.top = paddingHeight/2.f;
            [shareBackgournd addSubview:button];
        }
        [_contentView addSubview:shareBackgournd];
        
        [self addSubview:_contentView];
        
        // Line View
        //        UIView *lineView2 = [UIView lineViewWithWidth:_contentView.width yPoint:topLable.bottom withColor:[UIColor defaultLineColor]];
        //        lineView2.top = [buttonsArray[0] bottom]+5.f;
        //        [_contentView addSubview:lineView];
        //        [_contentView addSubview:lineView];
    }
    return _contentView;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Action
////////////////////////////////////////////////////////////////////////////////////

- (void)cancelButtonAction
{
    [self hide];
    if (self.cancelActionBlock) {
        self.cancelActionBlock();
    }
}

- (void)button1Action:(id)sender
{
    [self hide];
    if (self.timeLineAction) {
        self.timeLineAction();
    }
}

- (void)button2Action:(id)sender
{
    [self hide];
    if (self.qZoneAction) {
        self.qZoneAction();
    }
}

- (void)button3Action:(id)sender
{
    [self hide];
    if (self.QQAction) {
        self.QQAction();
    }
}

- (void)button4Action:(id)sender
{
    [self hide];
    if (self.weChatAction) {
        self.weChatAction();
    }
}

- (void)button5Action:(id)sender
{
    [self hide];
    if (self.facebookAction) {
        self.facebookAction();
    }
}

- (void)button6Action:(id)sender
{
    [self hide];
    if (self.whatsappAction) {
        self.whatsappAction();
    }
}

- (void)button7Action:(id)sender
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"WeChat-Timeline",@"WeChat-Friend", nil];
    [sheet showInView:self];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self hide];
//        [[NAShareManager shareManager] shareWithType:ShareType_weixinTimeline];
    }else if (buttonIndex == 1) {
        [self hide];
//        [[NAShareManager shareManager] shareWithType:ShareType_weixinsence];
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
        [[FGShareSheet keyWindow] addSubview:self];
        self.backgroundView.hidden = NO;
        self.backgroundView.alpha = 0;
        self.contentView.top = self.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0.65f;
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

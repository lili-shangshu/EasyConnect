//
//  DropDownButton.m
//  IosBasic
//
//  Created by junshi on 16/1/26.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "DropDownButton.h"
#import "CommonDefine.h"


@implementation DropDownButton

- (id)initDropDownButtonWithTitles:(NSArray*)titles{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BUTTON_HEIGHT)];
    if (self) {
        _isButton = NO;
        _count = titles.count;
        [self addButtonToView:titles];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu:) name:@"hideMenu" object:_lastTapObj];
    }
    return self;
}

- (void)addButtonToView:(NSArray *)titles {
    for (int i = 0; i < _count; i++) {
        UIButton *button = [self makeButton:[titles objectAtIndex:i] andIndex:i];
        [self addSubview:button];
        if (i > 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x, 10, 1, 20)];
            lineView.backgroundColor = [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1.0f];
            [self addSubview:lineView];
        }
    }
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, BUTTON_HEIGHT, SCREEN_WIDTH, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1.0f];
    [self addSubview:bottomLine];
}

- (UIButton *)makeButton:(NSString *) title andIndex:(int)index{
    float width = [self returnTitlesWidth];
    float offsetX = width * index;
    _image = [UIImage imageNamed:@"expandableImage"];
    float padding = (width - (_image.size.width + [title sizeWithFont:[UIFont systemFontOfSize:13.0f]].width)) / 2;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, width, BUTTON_HEIGHT)];
    button.tag = 10000 + index;
    [button setImage:_image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(11, [title sizeWithFont:[UIFont systemFontOfSize:13.0f]].width + padding+5 , 11, 0)];
    if(IS_IPHONE5 || IS_IPHONE4){
       [button.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    }else{
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.5f]];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(11, 0, 11, _image.size.width +25)];
    [button setBackgroundColor:[UIColor spLightWhriteColor]];
    [button setTitleColor:[UIColor spBrownColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (float)returnTitlesWidth {
    float width = SCREEN_WIDTH / _count;
    return width;
}

- (void)showMenuAction:(UIButton *)selectedButton {
//    NSInteger i = [selectedButton tag];
    [self openMenuBtnAnimation:selectedButton];
     NAPostNotification(@"DropDownButtonClick", nil);
}

- (void)openMenuBtnAnimation:(UIButton *)selectedButton{
    NSInteger index = [selectedButton tag];
    if (_lastTap != index) {
        if (_lastTap > 0) {
            [self changeButtionTag:_lastTap Rotation:0];
        }
        _lastTap = index;
        _isButton = NO;
        [self changeButtionTag:index Rotation:M_PI];
        [self.delegate showMenu:selectedButton];
    } else {
        _isButton = YES;
        [self changeButtionTag:_lastTap Rotation:0];
        _lastTap = 0;
        [self.delegate hideMenu];
    }
}

- (void)hideMenu:(NSNotification *)notification {
    _lastTapObj = [notification object];
    if (_isButton != YES) {
        [self changeButtionTag:([_lastTapObj intValue] + 10000) Rotation:0];
        _isButton = NO;
    }
    _lastTap = 0;
}

- (void)changeButtionTag:(NSInteger)index Rotation:(CGFloat)angle {
    [UIView animateWithDuration:0.1f animations:^{
        UIButton *btn = (UIButton *)[self viewWithTag:index];
        if (angle == 0) {
            [btn setBackgroundColor:[UIColor spLightWhriteColor]];
        } else {
            [btn setBackgroundColor:[UIColor colorWithRed:(221.0/255.0) green:(221.0/255.0) blue:(221.0/255.0) alpha:1.0f]];
        }
        btn.imageView.transform = CGAffineTransformMakeRotation(angle);
    }];
}

//移除观察者对象
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


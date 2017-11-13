//
//  FGImageView.m
//  FlyGift
//
//  Created by Nathan Ou on 15/1/10.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NAImageView.h"

@interface NAImageView ()

@property (nonatomic, assign) BOOL readyToSetImage;
@property (nonatomic, assign) BOOL firstLoad;

@end

@implementation NAImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.readyToSetImage = NO;
        self.image = [UIImage imageNamed:@"loading"];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor NA_ColorWithR:247 g:247 b:247];
        self.animated = YES;
        
        self.coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.coverImageView.alpha = 0;
        self.coverImageView.backgroundColor = [UIColor clearColor];
        self.coverImageView.image = nil;
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.clipsToBounds = YES;
        self.onlyFirstLoadWithFaddingAnimation = YES;
        self.firstLoad = YES;
        
        [self addSubview:self.coverImageView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.coverImageView.frame = self.bounds;
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    if (self.readyToSetImage) {
        self.coverImageView.contentMode = contentMode;
    }else
        [super setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setImage:(UIImage *)image
{
    if (!self.readyToSetImage){
        [super setImage:image];
        self.readyToSetImage = YES;
    }
    else
    {
        if (self.animated && self.firstLoad) {
            self.coverImageView.image = image;
            self.coverImageView.alpha = 0.f;
            [UIView animateWithDuration:0.25 animations:^{
                self.coverImageView.alpha = 1.f;
            }];
        }else{
            self.coverImageView.alpha = 1.f;
            self.coverImageView.image = image;
        }
        self.firstLoad = NO;
    }
}

- (void)setDefatulImage:(UIImage *)image
{
    self.readyToSetImage = NO;
    self.image = image;
}

- (BOOL)firstLoad
{
    if (!self.onlyFirstLoadWithFaddingAnimation) {
        return YES;
    }else
        return _firstLoad;
}

- (UIImage *)image
{
    if (self.coverImageView) {
        if (self.coverImageView.image) {
            return self.coverImageView.image;
        }else
            return [super image];
    }else
        return [super image];
}

- (void)setActionButton:(UIButton *)actionButton
{
    if (_actionButton) {
        [_actionButton removeFromSuperview];
        _actionButton = nil;
    }
    actionButton.frame = self.bounds;
    _actionButton = actionButton;
    [self addSubview:actionButton];
}

@end

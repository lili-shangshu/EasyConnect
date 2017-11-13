//
//  NAAccesorryView.m
//  FlyGift
//
//  Created by Nathan Ou on 14/12/21.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import "NAAccesorryView.h"

@interface NAAccesorryView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NAAccesorryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self.textLabel setLabelWith:@"" color:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14.f] aliment:NSTextAlignmentRight];
        self.textLabel.width = self.width - kLastAccesorryPadding;
        
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)setAccessoryImage:(UIImage *)accessoryImage
{
    if (self.leftImageView) {
        self.leftImageView.hidden = YES;
        [self.leftImageView removeFromSuperview];
    }
    
    _accessoryImage = accessoryImage;
    self.imageView.image = _accessoryImage;
//    [self.imageView sizeToFit];
    self.imageView.size = CGSizeMake(8, 15);
    
    self.imageView.right = self.width - kLastAccesorryPadding;
    self.imageView.y = self.textLabel.y;
    
    self.textLabel.width = self.imageView.left-kPaddingBetweentLabelAccessory;
}

- (void)setLeftImageView:(UIImageView *)leftImageView
{
    if (_leftImageView) {
        _leftImageView.hidden = YES;
        [_leftImageView removeFromSuperview];
    }
    
    _leftImageView = leftImageView;
    if (_leftImageView) {
        self.height = _leftImageView.height>_imageView.height?_leftImageView.height:_imageView.height;
        
        [_leftImageView centerAlignVerticalForView:self];
        [_imageView centerAlignVerticalForView:self];
        
        self.textLabel.hidden = YES;
        _leftImageView.right = self.textLabel.right;
        
        [self addSubview:_leftImageView];
    }
}

@end

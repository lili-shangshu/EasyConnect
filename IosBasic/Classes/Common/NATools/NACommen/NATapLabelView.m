//
//  NATapLabelView.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/31.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NATapLabelView.h"

@interface NATapLabelView ()

@property (nonatomic, strong) UILabel *mainLabel;

@end

@implementation NATapLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        [label setLabelWith:@"" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:10.f] aliment:NSTextAlignmentCenter];
        self.mainLabel = label;
        [self addSubview:label];
    }
    return self;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.mainLabel.font = font;
    [self updateLabelPosition];
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.mainLabel.text = text;
    [self updateLabelPosition];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.mainLabel.textColor = textColor;
    [self updateLabelPosition];
}

- (void)updateLabelPosition
{
    [self.mainLabel sizeToFit];
    [self.mainLabel centerAlignForView:self];
}

@end

//
//  FGOperationButton.m
//  FlyGift
//
//  Created by Nathan Ou on 14/12/22.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import "FGOperationButton.h"

@interface FGOperationButton ()

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *disableImage;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FGOperationButton

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title images:nil];
}

- (instancetype)initWithTitle:(NSString *)title images:(NSArray *)images
{
    return [self initWithTitle:title titleFont:[UIFont systemFontOfSize:13.f] images:images];
}

- (instancetype)initWithTitle:(NSString *)title titleFont:(UIFont *)titleFont images:(NSArray *)images
{
    self = [super init];
    if (self) {
        
        self.title = title;
        if (images) self.images = [NSMutableArray arrayWithArray:images];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setLabelWith:title color:[UIColor lightGrayColor] font:titleFont aliment:NSTextAlignmentCenter];
        [self.titleLabel sizeToFit];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.iconButton setImage:self.normalImage forState:UIControlStateNormal];
        if (self.selectedImage ) [self.iconButton setImage:self.selectedImage forState:UIControlStateHighlighted];
        self.iconButton.userInteractionEnabled = NO;
        [self.iconButton sizeToFit];
        
        // 计算View的大小
        CGFloat padding = 5.f;
        CGSize viewSize = CGSizeMake(self.titleLabel.width>=self.iconButton.width?self.titleLabel.width:self.iconButton.width, self.iconButton.height+padding+self.titleLabel.height);
        self.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
        
        // 设置控件的位置
        self.iconButton.top = 0;
        [self.iconButton centerAlignHorizontalForView:self];
        
        self.titleLabel.top = self.iconButton.bottom+padding;
        [self.titleLabel centerAlignHorizontalForView:self];
        
        // 虚拟点击按钮
        self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton.frame = self.bounds;
        
        // Add Subviews
        [self addSubview:self.iconButton];
        [self addSubview:self.titleLabel];
        [self addSubview:self.actionButton];
        
    }
    return self;
}

- (UIImage *)normalImage
{
    if (!_normalImage) {
        _normalImage = self.images[0];
    }
    
    return _normalImage;
}

- (UIImage *)selectedImage
{
    if (!_selectedImage) {
        
        if (self.images.count>1) {
            _selectedImage = self.images[1];
        }
    }
    return _selectedImage;
}

- (UIImage *)disableImage
{
    if (!_disableImage) {
        if (self.images.count > 2) {
            _disableImage = self.images[2];
        }
    }
    return _disableImage;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    self.actionButton.tag = tag;
}

- (void)setHighLighted:(BOOL)highLighted
{
    _iconButton.highlighted = highLighted;
    _actionButton.userInteractionEnabled = !highLighted;
}

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
        
    }
    
    return _images;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.actionButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)targetHightLightedFromNormal
{
    self.iconButton.highlighted = YES;
}

- (void)targetHightLightedToNormal
{
    self.iconButton.highlighted = NO;
}

- (void)setTitleWithString:(NSString *)title
{
    self.title = title;
    self.titleLabel.text = title;
}

- (void)setButtonImageWithImage:(UIImage *)image
{
    [self.iconButton setImage:image forState:UIControlStateNormal];
}

- (void)setTitleFont:(UIFont *)font color:(UIColor *)color
{
    self.titleLabel.top = self.titleLabel.top+5.f;
    self.titleLabel.font = font;
    self.titleLabel.textColor = color;
}

@end

//
//  FGOperationButton.h
//  FlyGift
//
//  Created by Nathan Ou on 14/12/22.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGOperationButton : UIView

@property (nonatomic, assign) BOOL highLighted;

@property (nonatomic, strong) id object;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title images:(NSArray *)images;
- (instancetype)initWithTitle:(NSString *)title titleFont:(UIFont *)titleFont images:(NSArray *)images;

- (void)setTitleWithString:(NSString *)title;
- (void)setButtonImageWithImage:(UIImage *)image;
- (void)setTitleFont:(UIFont *)font color:(UIColor *)color;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

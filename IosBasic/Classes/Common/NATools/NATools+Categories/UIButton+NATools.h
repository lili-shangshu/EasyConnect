//
//  UIButton+NATools.h
//  MyCollections
//
//  Created by Nathan on 14-9-19.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NATools)

+ (instancetype)NA_RoundRectButtonWithTitle:(NSString *)string backgroundColor:(UIColor *)color cornerRadius:(CGFloat)radius;

- (void)xr_setButtonImageWithUrl:(NSString *)urlStr;

@end
